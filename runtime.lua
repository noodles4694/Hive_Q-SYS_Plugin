-- Logic to deal with connection and disconnection of the Hive player
function HiveConnectStatus(status, message)
  LogDebug("Setting connected status to " .. tostring(status))
  if status == true then
    SetOnline()
    WatchParameters()
    UpdateInfo()
    PollInfo()
    UpdateMediaFolders()
    FetchVideoPreviews()
  else
    SetMissing(message or "Offline")
    BlankPreviews()
  end
end

-- Watch for parameter changes from the Hive player
function WatchParameters()
  -- Watch for JSON updates
  LogDebug("Setting up JSON watchers")
  WatchPatchJSON("/System Settings", ProcessJSONUpdate)
  WatchPatchJSON("/Media List", ProcessJSONUpdate)
  WatchPatchJSON("/Play List", ProcessJSONUpdate)
  WatchPatchJSON("/Timecode Cue List", ProcessJSONUpdate)
  WatchPatchJSON("/Schedule", ProcessJSONUpdate)
  WatchPatchJSON("/Timeline", ProcessJSONUpdate)
  WatchPatchJSON("/Output Mapping", ProcessJSONUpdate)
  WatchPatchDouble("/Playlist Control/Playlist Controller 1/Row Index", ProcessPlaylistRowUpdate)
  -- get the LUT options and update controls
  -- set the RAW mode so we can parse the raw data manually
  GetPatchJSON("/LUT Colour Modes", ProcessLUTData, true)
  LogDebug("LUT options requested")
  WatchPatchString(
    "/Status/Text",
    function(path, value)
      Controls.Activity.String = value
    end
  )

  -- Watch for value changes in layer parameters
  LogDebug("Setting up layer parameter watchers")
  for i = 1, layerCount do
    for _, parameter in ipairs(control_list) do
      if parameter.Watch == true then
        local path = string.format("/LAYER %s/%s/Value", i, parameter.Path)
        WatchPatchDouble(path, ProcessDoubleUpdate)
      end
    end
  end

  -- Watch for value changes in transport control parameters
  LogDebug("Setting up transport control watchers")
  for i = 1, layerCount do
    WatchPatchDouble(string.format("/LAYER %s/Transport Control/Media Time/Value", i), ProcessTransportUpdate)
  end
end

-- Poll and update the engine FPS and BeeSync status every second
function PollInfo()
  if wsConnected == true then
    LogDebug("Polling engine FPS")
    GetPatchString(
      "/Mapping/Render Resolution/FPS",
      function(path, value)
        LogDebug("Engine FPS: " .. value)
        engineFps = tonumber(value) or 0
        Controls.EngineFPS.String = value
      end
    )
    UpdateSyncStatus()
    UpdateStatus()
  end
  if wsConnected then
    Timer.CallAfter(PollInfo, 1)
  end
end

function UpdateStatus()
  if deviceInfo and wsConnected then
    -- OK status ("" or "OK")
    if deviceInfo.status == "OK" then
      -- warn if less than 50Gb free
      if deviceInfo.space < (1024 * 1024 * 1024 * 50) then
        -- check is fps has dropped to below 80% of output rate
        SetCompromised("Low Disk Space")
      elseif engineFps < (deviceInfo.rate * 0.8) then
        SetCompromised("Low FPS")
      else
        SetOnline()
      end
    else
      SetFault(deviceInfo.status)
    end
  end
end

-- Poll and update the BeeSync status
function UpdateSyncStatus()
  if wsConnected ~= true then
    return
  end
  LogDebug("Polling BeeSync status")
  local url = string.format("http://%s/api/getBeeSyncStatus", ipAddress)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        local info = rapidjson.decode(data)
        LogDebug("BeeSync status: " .. info.status)
        Controls.SyncStatus.String = info.status
      else
        LogError("Failed to get BeeSync status: HTTP " .. tostring(code))
      end
    end
  }
end

-- Set the value of a layer parameter
function Send(layer, cmd, val)
  LogDebug(string.format("Sending command to layer %s: %s = %s", layer, cmd, tostring(val)))
  local path = "/LAYER " .. layer .. "/" .. cmd .. "/Value"
  SetPatchDouble(path, val)
end

-- Set a JSON data value in full
function SendJson(cmd, val)
  LogDebug(string.format("Sending JSON command: %s = %s", cmd, rapidjson.encode(val)))
  local path = "/" .. cmd
  SetPatchJSON(path, val)
end

-- Update a section of JSON data value
function UpdateJson(cmd, val)
  LogDebug(string.format("Updating JSON command: %s = %s", cmd, rapidjson.encode(val)))
  local path = "/" .. cmd
  UpdatePatchJSON(path, val)
end

-- Process the LUT data received from the Hive player
function ProcessLUTData(path, data)
  -- The LUT list is inside a JSON object under the "Value" key
  -- however it is not indexed so we have to extract the string pairs manually
  -- in order to maintain the ordering
  -- this is not ideal but it works
  LogDebug("Processing LUT data")
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
      lutList = {
        ["NONE"] = 0
      }
      lutChoices = {}
      local idx = 1
      table.insert(lutChoices, "NONE") -- Add "NONE" option
      local valueBlock = subStr:sub(1, endPos)
      -- now extract all keys inside "Value"
      for k in valueBlock:gmatch('"([^"]+)"%s*:') do
        if k ~= "Value" then
          table.insert(lutChoices, k)
          lutList[k] = idx
          idx = idx + 1
        end
      end
      for i = 1, layerCount do
        Controls.Lut[i].Choices = lutChoices
      end
    end
  else
    LogError("Failed to find LUT Value block in JSON data")
  end
end

-- Handle transport control updates from the Hive player
function ProcessTransportUpdate(path, value)
  local layer, parameter = path:match("/LAYER (%d+)/(%P+)")
  if parameter == "Transport Control" then
    local layer, parameter, subParameter = path:match("/LAYER (%d+)/(%P+)/(%P+)")
    layer = tonumber(layer)
    local currentFileName = fileListNames[selectedFile[tonumber(layer)]] or ""
    if subParameter == "Media Time" then
      if not seekTimerList[tonumber(layer)]:IsRunning() then
        if
          currentFileName == "" or fileMetadataList[currentFileName] == nil or
            fileMetadataList[currentFileName].duration == 0
         then
          Controls.Seek[layer].Position = 0
          Controls.TimeElapsed[layer].String = os.date("!%X", 0)
        else
          local pos = tonumber(value) / fileMetadataList[currentFileName].duration
          Controls.Seek[layer].Position = pos
          Controls.TimeElapsed[layer].String = os.date("!%X", math.floor(value))
        end
      end
    end
  else
    LogError("Unknown transport parameter: " .. par)
  end
end

-- Handle playlist row updates from the Hive player
function ProcessPlaylistRowUpdate(path, value)
  LogDebug("Playlist active row updated to " .. tostring(value + 1))
  playlistActiveRow = value + 1 -- convert from 0 based to 1 based
  Controls.PlaylistCurrentRow.Value = playlistActiveRow
end

-- Handle double updates from the Hive player
function ProcessDoubleUpdate(path, value)
  LogDebug("Processing double update: " .. path .. " = " .. tostring(value))
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
      if (control ~= "") then
        if parameter == "FILE SELECT" then
          selectedFile[tonumber(layer)] = value
          UpdateSelectedFileInfo(value, layer)
        elseif parameter == "FOLDER SELECT" then
          Controls.FolderSelectIndex[layer].Value = value
          for k, v in pairs(folderList) do
            if v == value then
              Controls[control][layer].String = k
              break
            end
          end
        elseif parameter == "LUT" then
          Controls.LutIndex[layer].Value = value
          for k, v in pairs(lutList) do
            if v == value then
              Controls[control][layer].String = k
              break
            end
          end
        elseif parameter:sub(-5, -1) == "FRAME" then
          Controls[control][layer].Value = value
        elseif parameter == "PLAY MODE" then
          local key = GetTableKey(playModeKeys, playModeValues, value)
          Controls[control][layer].String = key
          Controls.PlayModeIndex[layer].Value = value
        elseif parameter == "FRAMING MODE" then
          local key = GetTableKey(framingModeKeys, framingModeValues, value)
          Controls[control][layer].String = key
          Controls.FramingModeIndex[layer].Value = value
        elseif parameter == "BLEND MODE" then
          local key = GetTableKey(blendModeKeys, blendModeValues, value)
          Controls[control][layer].String = key
          Controls.BlendModeIndex[layer].Value = value
        elseif parameter == "TRANSITION MODE" then
          local key = GetTableKey(transitionModeKeys, transitionModeValues, value)
          Controls[control][layer].String = key
          Controls.TransitionModeIndex[layer].Value = value
        elseif parameter == "FX1 SELECT" then
          local key = GetTableKey(fxKeys, fxValues, value)
          Controls[control][layer].String = key
          Controls.FX1SelectIndex[layer].Value = value
        elseif parameter == "FX2 SELECT" then
          local key = GetTableKey(fxKeys, fxValues, value)
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
        LogError("Unknown layer parameter: " .. path)
      end
    end
  end
end

function UpdateSelectedFileInfo(value, layer)
  local found = false
  for media = 1, mediaItemCount do
    Controls[string.format("MediaThumbnail%s", media)][layer].Boolean = media == (value + 1)
  end
  local currentFileName = fileListNames[tonumber(value)] or ""
  UpdatePreviewThumbnail(layer, currentFileName)
  Controls.FileSelect[layer].String = currentFileName
  Controls.FileSelectIndex[layer].Value = tonumber(value)
  if fileMetadataList[currentFileName] then
    Controls.Duration[layer].String = os.date("!%X", math.floor(fileMetadataList[currentFileName].duration))
  else
    Controls.Duration[layer].String = os.date("!%X", 0)
  end
end

-- Clear the media list thumbnails and names
function ClearMediaThumbs()
  local iconStyleBlank = {
    DrawChrome = true,
    HorizontalAlignment = "Center",
    Legend = "",
    Padding = -12,
    Margin = 0,
    IconData = ""
  }
  local iconStyleBlankString = rapidjson.encode(iconStyleBlank)
  for i = 1, layerCount do
    for m = 1, mediaItemCount do
      Controls[string.format("MediaName%s", m)][i].String = ""
      Controls[string.format("MediaThumbnail%s", m)][i].Style = iconStyleBlankString
    end
  end
end

-- Handle JSON updates from the Hive player
function ProcessJSONUpdate(path, value)
  LogDebug("Processing JSON update: " .. path)
  if path == "/System Settings" then
    deviceSettings = value
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.SettingsJSON.String = rapidjson.encode(value)
    end
    UpdateInfo()
  elseif path == "/Media List" then
    local fileChoiceList = {}
    fileList = {}
    fileListNames = {}
    fileMetadataList = {}
    ClearMediaThumbs()
    for _, file in ipairs(value.files) do
      fileList[file.name] = file.fileIndex - 1
      fileListNames[file.fileIndex - 1] = file.name
      table.insert(fileChoiceList, file.name)
      fileMetadataList[file.name] = file
      for i = 1, layerCount do
        if Controls[string.format("MediaName%s", file.fileIndex)][i] then
          Controls[string.format("MediaName%s", file.fileIndex)][i].String = file.name
        end
      end
      GetFileThumbnail(file.fileIndex, file.name)
    end
    for i = 1, layerCount do
      Controls.FileSelect[i].Choices = fileChoiceList
      UpdateSelectedFileInfo(selectedFile[i], i)
    end
    -- let's update the system info as storage and num files might have changed
    UpdateInfo()
  elseif path == "/Output Mapping" then
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.MappingJSON.String = rapidjson.encode(value)
    end
  elseif path == "/Play List" then
    LogDebug(
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
    playlistRowCount = value.list and #value.list or 0
    Controls.PlaylistRows.Value = playlistRowCount
  elseif path == "/Timecode Cue List" then
    LogDebug(
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
    LogDebug("Schedule updated, enabled: " .. tostring(value.useSchedule))
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.SchedulerJSON.String = rapidjson.encode(value)
    end
    if value.useSchedule and value.useSchedule == 1 then
      Controls.ScheduleEnable.Boolean = true
    else
      Controls.ScheduleEnable.Boolean = false
    end
  elseif path == "/Timeline" then
    LogDebug("Timeline updated, enabled: " .. tostring(value.useTimeline))
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
function UpdateInfo()
  if wsConnected ~= true then
    return
  end
  LogDebug("Updating device info")
  local url = string.format("http://%s/api/getTileList", ipAddress)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        local info = rapidjson.decode(data)
        LogDebug("Device info received")
        Controls.Version.String = info.hiveVersion

        if info and info.tileList then
          deviceInfo = nil
          for _, tile in ipairs(info.tileList) do
            if CompareIps(tile.ipAddress, ipAddress) then
              deviceInfo = tile
              break
            end
          end
          if deviceInfo then
            Controls.Model.String = Properties.Model.Value
            Controls.MACAddress.String = Properties["MAC Address"].Value
            Controls.DeviceName.String = deviceInfo.deviceName
            Controls.IPAddress.String = deviceInfo.ipAddress
            Controls.Netmask.String = deviceInfo.netMask
            Controls.OutputFramerate.String = deviceInfo.rate
            Controls.OutputResolution.String = string.format("%s x %s", deviceInfo.resX, deviceInfo.resY)
            Controls.SerialNumber.String = deviceInfo.serial
            Controls.BeeType.String = (deviceInfo.beeType == 1) and "Queen" or "Worker"
            Controls.FileCount.String = deviceInfo.nFiles
            Controls.CpuPower.String = deviceInfo.power
            Controls.Universe.String = deviceSettings.dmxUniverse
            Controls.FreeSpace.String = string.format("%.2f GB", tonumber(deviceInfo.space) / (1024 * 1024 * 1024))
          end
        end
      else
        LogError("Failed to get device info: HTTP " .. tostring(code))
      end
    end
  }
end

-- Request and update the thumbnail for a specific media index and filename
function GetFileThumbnail(index, filename)
  if wsConnected ~= true then
    return
  end
  if index <= mediaItemCount then
    LogDebug("Requesting thumbnail for media index " .. tostring(index) .. ", file: " .. filename)
    HttpClient.Download {
      Url = string.format("http://%s/Thumbs/%s", ipAddress, filename:gsub("%.%w+", ".jpg")),
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
          for i = 1, layerCount do
            Controls[string.format("MediaThumbnail%s", index)][i].Style = rapidjson.encode(iconStyle)
          end
        end
      end
    }
  else
    LogError("Thumbnail index " .. tostring(index) .. " exceeds media item count of " .. tostring(mediaItemCount))
  end
end

-- Request and update the preview thumbnail for a specific layer and filename
function UpdatePreviewThumbnail(layer, filename)
  if wsConnected ~= true or tonumber(layer) > layerCount then
    return
  end
  LogDebug("Requesting preview for media  " .. filename)
  if fileList[filename] == nil then
    LogError("Filename " .. filename .. " not found in file list")

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
      Url = string.format("http://%s/Thumbs/%s", ipAddress, filename:gsub("%.%w+", ".jpg")),
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

function BlankPreviews()
  local iconStyleBlank = {
    DrawChrome = true,
    HorizontalAlignment = "Center",
    Legend = "",
    IconData = ""
  }
  local iconStyleBlankString = rapidjson.encode(iconStyleBlank)
  for i = 1, layerCount do
    Controls.LayerPreview[i].Style = iconStyleBlankString
  end
  Controls.OutputPreview.Style = iconStyleBlankString
end

-- Periodically fetch and update the output video preview
function FetchVideoPreviews()
  UpdateOutputVideoPreview()
  if wsConnected then
    local refreshPeriod = 1 / string.gsub(Properties["Preview Refresh"].Value, " fps", "")
    Timer.CallAfter(FetchVideoPreviews, refreshPeriod)
  end
end

-- Request and update the output video preview
function UpdateOutputVideoPreview()
  if Properties["Output Video Preview"].Value == "Disabled" or not Controls.PreviewEnable.Boolean then
    return
  end
  LogDebug("Requesting output preview frame")
  local url = string.format("http://%s/api/getOutputFrame", ipAddress)
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
        LogError("Failed to get output frame data ")
      end
    end
  }
end

-- retrieve the list of availiable media fiolders and update the options in he comboboxes
function UpdateMediaFolders()
  if wsConnected ~= true then
    return
  end
  LogDebug("Updating media folder list")
  url = string.format("http://%s/api/getMediaFoldersList", ipAddress)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        LogDebug("Media folder list received")
        local folders = rapidjson.decode(data)
        folderList = {
          ["MEDIA"] = 0 -- Default folder
        }
        local index = 1
        for _, folder in pairs(folders.folders) do
          folderList[folder] = index
          index = index + 1
        end
        folderChoices = {}
        for k, v in pairs(folderList) do
          table.insert(folderChoices, k)
        end
        for i = 1, layerCount do
          Controls.FolderSelect[i].Choices = folderChoices
        end
      else
        LogError("Failed to get media folder list: HTTP " .. tostring(code))
      end
    end
  }
end

-- Set up seek timers and last value trackers
for layer, seekTimer in pairs(seekTimerList) do
  seekTimer.EventHandler = function(timer)
    if Controls.Seek[layer].String == seekLastValue[layer] then
      if Controls.FileSelect[layer].String ~= "" then
        local frame =
          math.floor(
          fileMetadataList[Controls.FileSelect[layer].String].duration *
            fileMetadataList[Controls.FileSelect[layer].String].rate *
            Controls.Seek[layer].Position
        )
        -- Seek to desired frame
        local path = string.format("/LAYER %s/Transport Control/MediaClockGenerator/Seek", layer)
        SetPatchDouble(path, frame)
      end
      seekTimerList[layer]:Stop()
    end
    seekLastValue[layer] = Controls.Seek[layer].String
  end
end

-- Initialize combobox choices
for i = 1, layerCount do
  Controls.PlayMode[i].Choices = playModeKeys
  Controls.FramingMode[i].Choices = framingModeKeys
  Controls.BlendMode[i].Choices = blendModeKeys
  Controls.TransitionMode[i].Choices = transitionModeKeys
  Controls.FX1Select[i].Choices = fxKeys
  Controls.FX2Select[i].Choices = fxKeys
end

-- Connect
SetInitializing("Connecting...")
if CheckValidIp(ipAddress) then
  Connect(ipAddress, HiveConnectStatus)
  LogMessage("Connecting to Hive player at " .. ipAddress)
else
  SetMissing("Invalid IP")
  LogError("Invalid IP address: " .. ipAddress)
end
