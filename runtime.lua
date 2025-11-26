-- Logic to deal with connection and disconnection of the Hive player
function FnHiveConnectStatus(status, message)
  FnLogDebug("Setting connected status to " .. tostring(status))
  if status == true then
    SetOnline()
    FnWatchParameters()
    FnUpdateInfo()
    FnPollInfo()
    FnUpdateMediaFolders()
    FnFetchVideoPreviews()
  else
    SetMissing(message or "Offline")
    FnBlankPreviews()
  end
end

-- Watch for parameter changes from the Hive player
function FnWatchParameters()
  -- Watch for JSON updates
  FnLogDebug("Setting up JSON watchers")
  WatchPatchJSON("/System Settings", FnProcessJSONUpdate)
  WatchPatchJSON("/Media List", FnProcessJSONUpdate)
  WatchPatchJSON("/Play List", FnProcessJSONUpdate)
  WatchPatchJSON("/Timecode Cue List", FnProcessJSONUpdate)
  WatchPatchJSON("/Schedule", FnProcessJSONUpdate)
  WatchPatchJSON("/Timeline", FnProcessJSONUpdate)
  WatchPatchJSON("/Output Mapping", FnProcessJSONUpdate)
  WatchPatchDouble("/Playlist Control/Playlist Controller 1/Row Index", FnProcessPlaylistRowUpdate)
  -- get the LUT options and update controls
  -- set the RAW mode so we can parse the raw data manually
  GetPatchJSON("/LUT Colour Modes", FnProcessLUTData, true)
  FnLogDebug("LUT options requested")
  WatchPatchString(
    "/Status/Text",
    function(path, value)
      Controls.Activity.String = value
    end
  )

  -- Watch for value changes in layer parameters
  FnLogDebug("Setting up layer parameter watchers")
  for i = 1, layer_count do
    for _, parameter in ipairs(control_list) do
      if parameter.Watch == true then
      local path = string.format("/LAYER %s/%s/Value", i, parameter.Path)
      WatchPatchDouble(path, FnProcessDoubleUpdate)
      end
    end
  end

  -- Watch for value changes in transport control parameters
  FnLogDebug("Setting up transport control watchers")
  for i = 1, layer_count do
    WatchPatchDouble(string.format("/LAYER %s/Transport Control/Media Time/Value", i), FnProcessTransportUpdate)
  end
end

-- Poll and update the engine FPS and BeeSync status every second
function FnPollInfo()
  if wsConnected == true then
    FnLogDebug("Polling engine FPS")
    GetPatchString(
      "/Mapping/Render Resolution/FPS",
      function(path, value)
        FnLogDebug("Engine FPS: " .. value)
        engine_fps = tonumber(value) or 0
        Controls.EngineFPS.String = value
      end
    )
    FnUpdateSyncStatus()
    FnUpdateStatus()
  end
  if wsConnected then
    Timer.CallAfter(FnPollInfo, 1)
  end
end

function FnUpdateStatus()
  if device_info and wsConnected then
    -- OK status ("" or "OK")
    if device_info.status == "OK" then
      -- warn if less than 50Gb free
      if device_info.space < (1024 * 1024 * 1024 * 50) then
        -- check is fps has dropped to below 80% of output rate
        SetCompromised("Low Disk Space")
      elseif engine_fps < (device_info.rate * 0.8) then
        SetCompromised("Low FPS")
      else
        SetOnline()
      end
    else
      SetFault(device_info.status)
    end
  end
end

-- Poll and update the BeeSync status
function FnUpdateSyncStatus()
  if wsConnected ~= true then
    return
  end
  FnLogDebug("Polling BeeSync status")
  local url = string.format("http://%s/api/getBeeSyncStatus", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        local info = rapidjson.decode(data)
        FnLogDebug("BeeSync status: " .. info.status)
        Controls.SyncStatus.String = info.status
      else
        FnLogError("Failed to get BeeSync status: HTTP " .. tostring(code))
      end
    end
  }
end

-- Set the value of a layer parameter
function FnSend(layer, cmd, val)
  FnLogDebug(string.format("Sending command to layer %s: %s = %s", layer, cmd, tostring(val)))
  local path = "/LAYER " .. layer .. "/" .. cmd .. "/Value"
  SetPatchDouble(path, val)
end

-- Set a JSON data value in full
function FnSendJson(cmd, val)
  FnLogDebug(string.format("Sending JSON command: %s = %s", cmd, rapidjson.encode(val)))
  local path = "/" .. cmd
  SetPatchJSON(path, val)
end

-- Update a section of JSON data value
function FnUpdateJson(cmd, val)
  FnLogDebug(string.format("Updating JSON command: %s = %s", cmd, rapidjson.encode(val)))
  local path = "/" .. cmd
  UpdatePatchJSON(path, val)
end

-- Process the LUT data received from the Hive player
function FnProcessLUTData(path, data)
  -- The LUT list is inside a JSON object under the "Value" key
  -- however it is not indexed so we have to extract the string pairs manually
  -- in order to maintain the ordering
  -- this is not ideal but it works
  FnLogDebug("Processing LUT data")
  -- find the start of the "Value" object
  local startPos = data:find('"Value"%s*:%s*{')
  if startPos then
    -- extract substring from "Value": { ... }
    local subStr = data:sub(startPos)
    -- stop at the matching closing brace for Value
    local braceCount, endPos = 0, nil
    for i = 1, #subStr do
      local c = subStr:sub(i, i)
      if c == "{" then
        braceCount = braceCount + 1
      elseif c == "}" then
        braceCount = braceCount - 1
        if braceCount == 0 then
          endPos = i
          break
        end
      end
    end
    if endPos then
      lut_list = {
        ["NONE"] = 0
      }
      lut_choices = {}
      local idx = 1
      table.insert(lut_choices, "NONE") -- Add "NONE" option
      local valueBlock = subStr:sub(1, endPos)
      -- now extract all keys inside "Value"
      for k in valueBlock:gmatch('"([^"]+)"%s*:') do
        if k ~= "Value" then
          table.insert(lut_choices, k)
          lut_list[k] = idx
          idx = idx + 1
        end
      end
      for i = 1, layer_count do
        Controls.Lut[i].Choices = lut_choices
      end
    end
  else
    FnLogError("Failed to find LUT Value block in JSON data")
  end
end

-- Handle transport control updates from the Hive player
function FnProcessTransportUpdate(path, value)
  local layer, parameter = path:match("/LAYER (%d+)/(%P+)")
  if parameter == "Transport Control" then
    local layer, parameter, sub_parameter = path:match("/LAYER (%d+)/(%P+)/(%P+)")
    layer = tonumber(layer)
    local currentFileName = file_list_names[selected_file[tonumber(layer)]] or ""
    if sub_parameter == "Media Time" then
      if not seek_timer_list[tonumber(layer)]:IsRunning() then
        if
          currentFileName == "" or file_metadata_list[currentFileName] == nil or
            file_metadata_list[currentFileName].duration == 0
         then
          Controls.Seek[layer].Position = 0
          Controls.TimeElapsed[layer].String = os.date("!%X", 0)
        else
          local pos = tonumber(value) / file_metadata_list[currentFileName].duration
          Controls.Seek[layer].Position = pos
          Controls.TimeElapsed[layer].String = os.date("!%X", math.floor(value))
        end
      end
    end
  else
    FnLogError("Unknown transport parameter: " .. par)
  end
end

-- Handle playlist row updates from the Hive player
function FnProcessPlaylistRowUpdate(path, value)
  FnLogDebug("Playlist active row updated to " .. tostring(value + 1))
  playlist_active_row = value + 1 -- convert from 0 based to 1 based
  Controls.PlaylistCurrentRow.Value = playlist_active_row
end

-- Handle double updates from the Hive player
function FnProcessDoubleUpdate(path, value)
  FnLogDebug("Processing double update: " .. path .. " = " .. tostring(value))
  if path:sub(1, 6) == "/LAYER" then -- Layer parameter response
    local layer, parameter = path:match("/LAYER (%d+)/(%P+)/Value")
    layer = tonumber(layer)
    if parameter then
      local control = ""
      for _, param in ipairs(control_list) do
        if param.Path == parameter then
          control = param.Name
          break
        end
      end
      if( control ~= "" ) then
      if parameter == "FILE SELECT" then
        selected_file[tonumber(layer)] = value
        FnUpdateSelectedFileInfo(value, layer)
      elseif parameter == "FOLDER SELECT" then
        Controls.FolderSelectIndex[layer].Value = value
        for k, v in pairs(folder_list) do
          if v == value then
            Controls[control][layer].String = k
            break
          end
        end
      elseif parameter == "LUT" then
        Controls.LutIndex[layer].Value = value
        for k, v in pairs(lut_list) do
          if v == value then
            Controls[control][layer].String = k
            break
          end
        end
      elseif parameter:sub(-5, -1) == "FRAME" then
        Controls[control][layer].Value = value
      elseif parameter == "PLAY MODE" then
        local key = GetTableKey(play_mode_keys, play_mode_values, value)
        Controls[control][layer].String = key
        Controls.PlayModeIndex[layer].Value = value
      elseif parameter == "FRAMING MODE" then
        local key = GetTableKey(framing_mode_keys, framing_mode_values, value)
        Controls[control][layer].String = key
        Controls.FramingModeIndex[layer].Value = value
      elseif parameter == "BLEND MODE" then
        local key = GetTableKey(blend_mode_keys, blend_mode_values, value)
        Controls[control][layer].String = key
        Controls.BlendModeIndex[layer].Value = value
      elseif parameter == "TRANSITION MODE" then
        local key = GetTableKey(transition_mode_keys, transition_mode_values, value)
        Controls[control][layer].String = key
        Controls.TransitionModeIndex[layer].Value = value
      elseif parameter == "FX1 SELECT" then
        local key = GetTableKey(fx_keys, fx_values, value)
        Controls[control][layer].String = key
        Controls.FX1SelectIndex[layer].Value = value
      elseif parameter == "FX2 SELECT" then
        local key = GetTableKey(fx_keys, fx_values, value)
        Controls[control][layer].String = key
        Controls.FX2SelectIndex[layer].Value = value
      elseif parameter == "PLAY SPEED" or parameter == "SCALE" then
        if value >= 0.5 then
          Controls[control][layer].Position = (value - 0.4444444444444444) / 0.5555555555555556
        else
          Controls[control][layer].Position = value / 5
        end
      elseif parameter:sub(1, 3) == "MTC" then
        Controls[control][layer].Value = value
      elseif parameter:sub(1, 8) == "POSITION" then
        Controls[control][layer].Value = (value * 200) - 100
      elseif parameter:sub(1, 8) == "ROTATION" then
        Controls[control][layer].Value = (value * 2880) - 1440
      elseif parameter:sub(1, 19) == "TRANSITION DURATION" then
        Controls[control][layer].Value = value
      elseif
        parameter == "RED" or parameter == "BLUE" or parameter == "GREEN" or parameter == "SATURATION" or
          parameter == "CONTRAST"
       then
        Controls[control][layer].Value = (value * 200) - 100
      else -- parameters where data directly proportional to position
        Controls[control][layer].Position = value
      end
    else
      FnLogError("Unknown layer parameter: " .. path)
    end
  end
  end
end

function FnUpdateSelectedFileInfo(value, layer)
  local found = false
  for media = 1, media_item_count do
    Controls[string.format("MediaThumbnail%s", media)][layer].Boolean = media == (value + 1)
  end
  local currentFileName = file_list_names[tonumber(value)] or ""
  FnUpdatePreviewThumbnail(layer, currentFileName)
  Controls.FileSelect[layer].String = currentFileName
  Controls.FileSelectIndex[layer].Value = tonumber(value)
  if file_metadata_list[currentFileName] then
    Controls.Duration[layer].String = os.date("!%X", math.floor(file_metadata_list[currentFileName].duration))
  else
    Controls.Duration[layer].String = os.date("!%X", 0)
  end
end

-- Clear the media list thumbnails and names
function FnClearMediaThumbs()
  local iconStyleBlank = {
    DrawChrome = true,
    HorizontalAlignment = "Center",
    Legend = "",
    Padding = -12,
    Margin = 0,
    IconData = ""
  }
  local iconStyleBlankString = rapidjson.encode(iconStyleBlank)
  for i = 1, layer_count do
    for m = 1, media_item_count do
      Controls[string.format("MediaName%s", m)][i].String = ""
      Controls[string.format("MediaThumbnail%s", m)][i].Style = iconStyleBlankString
    end
  end
end

-- Handle JSON updates from the Hive player
function FnProcessJSONUpdate(path, value)
  FnLogDebug("Processing JSON update: " .. path)
  if path == "/System Settings" then
    device_settings = value
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.SettingsJSON.String = rapidjson.encode(value)
    end
    FnUpdateInfo()
  elseif path == "/Media List" then
    local file_choice_list = {}
    file_list = {}
    file_list_names = {}
    file_metadata_list = {}
    FnClearMediaThumbs()
    for _, file in ipairs(value.files) do
      file_list[file.name] = file.fileIndex - 1
      file_list_names[file.fileIndex - 1] = file.name
      table.insert(file_choice_list, file.name)
      file_metadata_list[file.name] = file
      for i = 1, layer_count do
        if Controls[string.format("MediaName%s", file.fileIndex)][i] then
          Controls[string.format("MediaName%s", file.fileIndex)][i].String = file.name
        end
      end
      FnGetFileThumbnail(file.fileIndex, file.name)
    end
    for i = 1, layer_count do
      Controls.FileSelect[i].Choices = file_choice_list
      FnUpdateSelectedFileInfo(selected_file[i], i)
    end
    -- let's update the system info as storage and num files might have changed
    FnUpdateInfo()
  elseif path == "/Output Mapping" then
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.MappingJSON.String = rapidjson.encode(value)
    end
  elseif path == "/Play List" then
    FnLogDebug(
      "Playlist updated, total items: " ..
        tostring(value.list and #value.list or 0) .. ", enabled: " .. tostring(value.usePlayList)
    )
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.PlaylistJSON.String = rapidjson.encode(value)
    end
    if value.usePlayList and value.usePlayList == 1 then
      Controls.PlaylistEnable.Boolean = true
    else
      Controls.PlaylistEnable.Boolean = false
    end
    playlist_row_count = value.list and #value.list or 0
    Controls.PlaylistRows.Value = playlist_row_count
  elseif path == "/Timecode Cue List" then
    FnLogDebug(
      "Timecode Cue List updated, layer 1 items: " ..
        tostring(value.layers[1] and #(value.layers[1].list) or 0) ..
          ", layer 2 items: " ..
            tostring(value.layers[2] and #(value.layers[2].list) or 0) ..
              ", layer 1 enabled: " ..
                tostring(value.layers[1] and value.layers[1].useCueList == 1) ..
                  ", layer 2 enabled: " .. tostring(value.layers[2] and value.layers[2].useCueList == 1)
    )
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.TimecodeJSON.String = rapidjson.encode(value)
    end
    if value.layers[1] and value.layers[1].useCueList == 1 then
      Controls.L1TimecodeEnable.Boolean = true
    else
      Controls.L1TimecodeEnable.Boolean = false
    end
    if value.layers[2] and value.layers[2].useCueList == 1 then
      Controls.L2TimecodeEnable.Boolean = true
    else
      Controls.L2TimecodeEnable.Boolean = false
    end
    Controls.L1TCRows.Value = value.layers[1] and #(value.layers[1].list) or 0
    Controls.L2TCRows.Value = value.layers[2] and #(value.layers[2].list) or 0
  elseif path == "/Schedule" then
    FnLogDebug("Schedule updated, enabled: " .. tostring(value.useSchedule))
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.SchedulerJSON.String = rapidjson.encode(value)
    end
    if value.useSchedule and value.useSchedule == 1 then
      Controls.ScheduleEnable.Boolean = true
    else
      Controls.ScheduleEnable.Boolean = false
    end
  elseif path == "/Timeline" then
    FnLogDebug("Timeline updated, enabled: " .. tostring(value.useTimeline))
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.TimelineJSON.String = rapidjson.encode(value)
    end
    if value.useTimeline and value.useTimeline == 1 then
      Controls.TimelineEnable.Boolean = true
    else
      Controls.TimelineEnable.Boolean = false
    end
  elseif path == "/Vioso WB Settings" then
  elseif path == "/Screenberry WB Settings" then
  end
end

-- Request and update the device information from the Hive player
function FnUpdateInfo()
  if wsConnected ~= true then
    return
  end
  FnLogDebug("Updating device info")
  local url = string.format("http://%s/api/getTileList", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        local info = rapidjson.decode(data)
        FnLogDebug("Device info received")
        Controls.Version.String = info.hiveVersion

        if info and info.tileList then
          device_info = nil
          for _, tile in ipairs(info.tileList) do
            if FnCompareIps(tile.ipAddress, ip_address) then
              device_info = tile
              break
            end
          end
          if device_info then
            Controls.DeviceName.String = device_info.deviceName
            Controls.IPAddress.String = device_info.ipAddress
            Controls.Netmask.String = device_info.netMask
            Controls.OutputFramerate.String = device_info.rate
            Controls.OutputResolution.String = string.format("%s x %s", device_info.resX, device_info.resY)
            Controls.SerialNumber.String = device_info.serial
            Controls.BeeType.String = (device_info.beeType == 1) and "Queen" or "Worker"
            Controls.FileCount.String = device_info.nFiles
            Controls.CpuPower.String = device_info.power
            Controls.Universe.String = device_settings.dmxUniverse
            Controls.FreeSpace.String = string.format("%.2f GB", tonumber(device_info.space) / (1024 * 1024 * 1024))
          end
        end
      else
        FnLogError("Failed to get device info: HTTP " .. tostring(code))
      end
    end
  }
end

-- Request and update the thumbnail for a specific media index and filename
function FnGetFileThumbnail(index, filename)
  if wsConnected ~= true then
    return
  end
  if index <= media_item_count then
    FnLogDebug("Requesting thumbnail for media index " .. tostring(index) .. ", file: " .. filename)
    HttpClient.Download {
      Url = string.format("http://%s/Thumbs/%s", ip_address, filename:gsub("%.%w+", ".jpg")),
      Headers = {},
      Auth = "basic",
      Timeout = 10,
      EventHandler = function(tbl, code, data, err, headers)
        if code == 200 then
          local iconStyle = {
            DrawChrome = true,
            HorizontalAlignment = "Center",
            Legend = "",
            Padding = -12,
            Margin = 0,
            IconData = Qlib.base64_enc(data)
          }
          for i = 1, layer_count do
            Controls[string.format("MediaThumbnail%s", index)][i].Style = rapidjson.encode(iconStyle)
          end
        end
      end
    }
  else
    FnLogError("Thumbnail index " .. tostring(index) .. " exceeds media item count of " .. tostring(media_item_count))
  end
end

-- Request and update the preview thumbnail for a specific layer and filename
function FnUpdatePreviewThumbnail(layer, filename)
  if wsConnected ~= true or tonumber(layer) > layer_count then
    return
  end
  FnLogDebug("Requesting preview for media  " .. filename)
  if file_list[filename] == nil then
    FnLogError("Filename " .. filename .. " not found in file list")

    local iconStyleBlank = {
      DrawChrome = true,
      HorizontalAlignment = "Center",
      Legend = "",
      IconData = ""
    }
    local iconStyleBlankString = rapidjson.encode(iconStyleBlank)
    Controls.LayerPreview[layer].Style = iconStyleBlankString
    if
      tonumber(layer) == 1 and
        (Properties["Output Video Preview"].Value == "Disabled" or not Controls.PreviewEnable.Boolean)
     then
      Controls.OutputPreview.Style = iconStyleBlankString
    end
  else
    HttpClient.Download {
      Url = string.format("http://%s/Thumbs/%s", ip_address, filename:gsub("%.%w+", ".jpg")),
      Headers = {},
      Auth = "basic",
      Timeout = 10,
      EventHandler = function(tbl, code, data, err, headers)
        if code == 200 then
          local iconStyle = {
            DrawChrome = false,
            Legend = "",
            IconData = Qlib.base64_enc(data)
          }
          Controls.LayerPreview[layer].Style = rapidjson.encode(iconStyle)
          if
            tonumber(layer) == 1 and
              (Properties["Output Video Preview"].Value == "Disabled" or not Controls.PreviewEnable.Boolean)
           then
            Controls.OutputPreview.Style = rapidjson.encode(iconStyle)
          end
        end
      end
    }
  end
end

function FnBlankPreviews()
  local iconStyleBlank = {
    DrawChrome = true,
    HorizontalAlignment = "Center",
    Legend = "",
    IconData = ""
  }
  local iconStyleBlankString = rapidjson.encode(iconStyleBlank)
  for i = 1, layer_count do
    Controls.LayerPreview[i].Style = iconStyleBlankString
  end
  Controls.OutputPreview.Style = iconStyleBlankString
end

-- Periodically fetch and update the output video preview
function FnFetchVideoPreviews()
  FnUpdateOutputVideoPreview()
  if wsConnected then
    local refresh_period = 1 / string.gsub(Properties["Preview Refresh"].Value, " fps", "")
    Timer.CallAfter(FnFetchVideoPreviews, refresh_period)
  end
end

-- Request and update the output video preview
function FnUpdateOutputVideoPreview()
  if Properties["Output Video Preview"].Value == "Disabled" or not Controls.PreviewEnable.Boolean then
    return
  end
  FnLogDebug("Requesting output preview frame")
  local url = string.format("http://%s/api/getOutputFrame", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode(
      {
        includeImageData = true,
        dualFramesRequest = false
      }
    ), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        local frameData = rapidjson.decode(data)
        local iconStyle = {
          DrawChrome = false,
          Legend = "",
          IconData = frameData.imgDataMapped
        }
        if wsConnected then
          Controls.OutputPreview.Style = rapidjson.encode(iconStyle)
        end
      else
        FnLogError("Failed to get output frame data ")
      end
    end
  }
end

-- retrieve the list of availiable media fiolders and update the options in he comboboxes
function FnUpdateMediaFolders()
  if wsConnected ~= true then
    return
  end
  FnLogDebug("Updating media folder list")
  url = string.format("http://%s/api/getMediaFoldersList", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        FnLogDebug("Media folder list received")
        local folders = rapidjson.decode(data)
        folder_list = {
          ["MEDIA"] = 0 -- Default folder
        }
        local index = 1
        for _, folder in pairs(folders.folders) do
          folder_list[folder] = index
          index = index + 1
        end
        folder_choices = {}
        for k, v in pairs(folder_list) do
          table.insert(folder_choices, k)
        end
        for i = 1, layer_count do
          Controls.FolderSelect[i].Choices = folder_choices
        end
      else
        FnLogError("Failed to get media folder list: HTTP " .. tostring(code))
      end
    end
  }
end

-- Set up seek timers and last value trackers
for layer, seek_timer in pairs(seek_timer_list) do
  seek_timer.EventHandler = function(timer)
    if Controls.Seek[layer].String == seek_last_value[layer] then
      if Controls.FileSelect[layer].String ~= "" then
        local frame =
          math.floor(
          file_metadata_list[Controls.FileSelect[layer].String].duration *
            file_metadata_list[Controls.FileSelect[layer].String].rate *
            Controls.Seek[layer].Position
        )
        -- Seek to desired frame
        local path = string.format("/LAYER %s/Transport Control/MediaClockGenerator/Seek", layer)
        SetPatchDouble(path, frame)
      end
      seek_timer_list[layer]:Stop()
    end
    seek_last_value[layer] = Controls.Seek[layer].String
  end
end

-- Initialize combobox choices
for i = 1, layer_count do
  Controls.PlayMode[i].Choices = play_mode_keys
  Controls.FramingMode[i].Choices = framing_mode_keys
  Controls.BlendMode[i].Choices = blend_mode_keys
  Controls.TransitionMode[i].Choices = transition_mode_keys
  Controls.FX1Select[i].Choices = fx_keys
  Controls.FX2Select[i].Choices = fx_keys
end

-- Connect
SetInitializing("Connecting...")
if FnCheckValidIp(ip_address) then
  Connect(ip_address, FnHiveConnectStatus)
  FnLogMessage("Connecting to Hive player at " .. ip_address)
else
  SetMissing("Invalid IP")
  FnLogError("Invalid IP address: " .. ip_address)
end
