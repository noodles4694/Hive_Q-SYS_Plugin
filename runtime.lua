-- Logic to deal with connection and disconnection of the Hive player
function fn_hive_connect_Status(status, message)
  fn_log_debug("Setting connected status to " .. tostring(status))
  if status == true then
    setOnline()
    fn_watch_parameters()
    fn_update_info()
    fn_poll_info()
    fn_update_media_folders()
    fn_fetch_video_previews()
  else
    setMissing(message or "Offline")
    fn_blank_previews()
  end
end

-- Watch for parameter changes from the Hive player
function fn_watch_parameters()
  -- Watch for JSON updates
  fn_log_debug("Setting up JSON watchers")
  watchPatchJSON("/System Settings", fn_process_JSON_update)
  watchPatchJSON("/Media List", fn_process_JSON_update)
  watchPatchJSON("/Play List", fn_process_JSON_update)
  watchPatchJSON("/Timecode Cue List", fn_process_JSON_update)
  watchPatchJSON("/Schedule", fn_process_JSON_update)
  watchPatchJSON("/Timeline", fn_process_JSON_update)
  watchPatchJSON("/Output Mapping", fn_process_JSON_update)
  watchPatchDouble("/Playlist Control/Playlist Controller 1/Row Index", fn_process_playlist_row_update)
  -- get the LUT options and update controls
  -- set the RAW mode so we can parse the raw data manually
  getPatchJSON("/LUT Colour Modes", fn_process_LUT_data, true)
  fn_log_debug("LUT options requested")
  watchPatchString(
    "/Status/Text",
    function(path, value)
      Controls.Activity.String = value
    end
  )

  -- Watch for value changes in layer parameters
  fn_log_debug("Setting up layer parameter watchers")
  for i = 1, layer_count do
    for _, parameter in ipairs(control_list) do
      if parameter.Watch == true then
      local path = string.format("/LAYER %s/%s/Value", i, parameter.Path)
      watchPatchDouble(path, fn_process_double_update)
      end
    end
  end

  -- Watch for value changes in transport control parameters
  fn_log_debug("Setting up transport control watchers")
  for i = 1, layer_count do
    watchPatchDouble(string.format("/LAYER %s/Transport Control/Media Time/Value", i), fn_process_transport_update)
  end
end

-- Poll and update the engine FPS and BeeSync status every second
function fn_poll_info()
  if wsConnected == true then
    fn_log_debug("Polling engine FPS")
    getPatchString(
      "/Mapping/Render Resolution/FPS",
      function(path, value)
        fn_log_debug("Engine FPS: " .. value)
        engine_fps = tonumber(value) or 0
        Controls.EngineFPS.String = value
      end
    )
    fn_update_sync_status()
    fn_update_status()
  end
  if wsConnected then
    Timer.CallAfter(fn_poll_info, 1)
  end
end

function fn_update_status()
  if device_info and wsConnected then
    -- OK status ("" or "OK")
    if device_info.status == "OK" then
      -- warn if less than 50Gb free
      if device_info.space < (1024 * 1024 * 1024 * 50) then
        -- check is fps has dropped to below 80% of output rate
        setCompromised("Low Disk Space")
      elseif engine_fps < (device_info.rate * 0.8) then
        setCompromised("Low FPS")
      else
        setOnline()
      end
    else
      setFault(device_info.status)
    end
  end
end

-- Poll and update the BeeSync status
function fn_update_sync_status()
  if wsConnected ~= true then
    return
  end
  fn_log_debug("Polling BeeSync status")
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
        fn_log_debug("BeeSync status: " .. info.status)
        Controls.SyncStatus.String = info.status
      else
        fn_log_error("Failed to get BeeSync status: HTTP " .. tostring(code))
      end
    end
  }
end

-- Set the value of a layer parameter
function fn_send(layer, cmd, val)
  fn_log_debug(string.format("Sending command to layer %s: %s = %s", layer, cmd, tostring(val)))
  local path = "/LAYER " .. layer .. "/" .. cmd .. "/Value"
  setPatchDouble(path, val)
end

-- Set a JSON data value in full
function fn_send_json(cmd, val)
  fn_log_debug(string.format("Sending JSON command: %s = %s", cmd, rapidjson.encode(val)))
  local path = "/" .. cmd
  setPatchJSON(path, val)
end

-- Update a section of JSON data value
function fn_update_json(cmd, val)
  fn_log_debug(string.format("Updating JSON command: %s = %s", cmd, rapidjson.encode(val)))
  local path = "/" .. cmd
  updatePatchJSON(path, val)
end

-- Process the LUT data received from the Hive player
function fn_process_LUT_data(path, data)
  -- The LUT list is inside a JSON object under the "Value" key
  -- however it is not indexed so we have to extract the string pairs manually
  -- in order to maintain the ordering
  -- this is not ideal but it works
  fn_log_debug("Processing LUT data")
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
    fn_log_error("Failed to find LUT Value block in JSON data")
  end
end

-- Handle transport control updates from the Hive player
function fn_process_transport_update(path, value)
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
    fn_log_error("Unknown transport parameter: " .. par)
  end
end

-- Handle playlist row updates from the Hive player
function fn_process_playlist_row_update(path, value)
  fn_log_debug("Playlist active row updated to " .. tostring(value + 1))
  playlist_active_row = value + 1 -- convert from 0 based to 1 based
  Controls.PlaylistCurrentRow.Value = playlist_active_row
end

-- Handle double updates from the Hive player
function fn_process_double_update(path, value)
  fn_log_debug("Processing double update: " .. path .. " = " .. tostring(value))
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
        fn_update_selected_file_info(value, layer)
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
        local key = get_table_key(play_mode_keys, play_mode_values, value)
        Controls[control][layer].String = key
        Controls.PlayModeIndex[layer].Value = value
      elseif parameter == "FRAMING MODE" then
        local key = get_table_key(framing_mode_keys, framing_mode_values, value)
        Controls[control][layer].String = key
        Controls.FramingModeIndex[layer].Value = value
      elseif parameter == "BLEND MODE" then
        local key = get_table_key(blend_mode_keys, blend_mode_values, value)
        Controls[control][layer].String = key
        Controls.BlendModeIndex[layer].Value = value
      elseif parameter == "TRANSITION MODE" then
        local key = get_table_key(transition_mode_keys, transition_mode_values, value)
        Controls[control][layer].String = key
        Controls.TransitionModeIndex[layer].Value = value
      elseif parameter == "FX1 SELECT" then
        local key = get_table_key(fx_keys, fx_values, value)
        Controls[control][layer].String = key
        Controls.FX1SelectIndex[layer].Value = value
      elseif parameter == "FX2 SELECT" then
        local key = get_table_key(fx_keys, fx_values, value)
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
      fn_log_error("Unknown layer parameter: " .. path)
    end
  end
  end
end

function fn_update_selected_file_info(value, layer)
  local found = false
  for media = 1, media_item_count do
    Controls[string.format("MediaThumbnail%s", media)][layer].Boolean = media == (value + 1)
  end
  local currentFileName = file_list_names[tonumber(value)] or ""
  fn_update_preview_thumbnail(layer, currentFileName)
  Controls.FileSelect[layer].String = currentFileName
  Controls.FileSelectIndex[layer].Value = tonumber(value)
  if file_metadata_list[currentFileName] then
    Controls.Duration[layer].String = os.date("!%X", math.floor(file_metadata_list[currentFileName].duration))
  else
    Controls.Duration[layer].String = os.date("!%X", 0)
  end
end

-- Clear the media list thumbnails and names
function fn_clear_media_thumbs()
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
function fn_process_JSON_update(path, value)
  fn_log_debug("Processing JSON update: " .. path)
  if path == "/System Settings" then
    device_settings = value
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.SettingsJSON.String = rapidjson.encode(value)
    end
    fn_update_info()
  elseif path == "/Media List" then
    local file_choice_list = {}
    file_list = {}
    file_list_names = {}
    file_metadata_list = {}
    fn_clear_media_thumbs()
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
      fn_get_file_thumbnail(file.fileIndex, file.name)
    end
    for i = 1, layer_count do
      Controls.FileSelect[i].Choices = file_choice_list
      fn_update_selected_file_info(selected_file[i], i)
    end
    -- let's update the system info as storage and num files might have changed
    fn_update_info()
  elseif path == "/Output Mapping" then
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.MappingJSON.String = rapidjson.encode(value)
    end
  elseif path == "/Play List" then
    fn_log_debug(
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
    fn_log_debug(
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
    fn_log_debug("Schedule updated, enabled: " .. tostring(value.useSchedule))
    if (Properties["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
      Controls.SchedulerJSON.String = rapidjson.encode(value)
    end
    if value.useSchedule and value.useSchedule == 1 then
      Controls.ScheduleEnable.Boolean = true
    else
      Controls.ScheduleEnable.Boolean = false
    end
  elseif path == "/Timeline" then
    fn_log_debug("Timeline updated, enabled: " .. tostring(value.useTimeline))
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
function fn_update_info()
  if wsConnected ~= true then
    return
  end
  fn_log_debug("Updating device info")
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
        fn_log_debug("Device info received")
        Controls.Version.String = info.hiveVersion

        if info and info.tileList then
          device_info = nil
          for _, tile in ipairs(info.tileList) do
            if fn_compare_ips(tile.ipAddress, ip_address) then
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
        fn_log_error("Failed to get device info: HTTP " .. tostring(code))
      end
    end
  }
end

-- Request and update the thumbnail for a specific media index and filename
function fn_get_file_thumbnail(index, filename)
  if wsConnected ~= true then
    return
  end
  if index <= media_item_count then
    fn_log_debug("Requesting thumbnail for media index " .. tostring(index) .. ", file: " .. filename)
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
    fn_log_error("Thumbnail index " .. tostring(index) .. " exceeds media item count of " .. tostring(media_item_count))
  end
end

-- Request and update the preview thumbnail for a specific layer and filename
function fn_update_preview_thumbnail(layer, filename)
  if wsConnected ~= true or tonumber(layer) > layer_count then
    return
  end
  fn_log_debug("Requesting preview for media  " .. filename)
  if file_list[filename] == nil then
    fn_log_error("Filename " .. filename .. " not found in file list")

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

function fn_blank_previews()
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
function fn_fetch_video_previews()
  fn_update_output_video_preview()
  if wsConnected then
    local refresh_period = 1 / string.gsub(Properties["Preview Refresh"].Value, " fps", "")
    Timer.CallAfter(fn_fetch_video_previews, refresh_period)
  end
end

-- Request and update the output video preview
function fn_update_output_video_preview()
  if Properties["Output Video Preview"].Value == "Disabled" or not Controls.PreviewEnable.Boolean then
    return
  end
  fn_log_debug("Requesting output preview frame")
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
        fn_log_error("Failed to get output frame data ")
      end
    end
  }
end

-- retrieve the list of availiable media fiolders and update the options in he comboboxes
function fn_update_media_folders()
  if wsConnected ~= true then
    return
  end
  fn_log_debug("Updating media folder list")
  url = string.format("http://%s/api/getMediaFoldersList", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        fn_log_debug("Media folder list received")
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
        fn_log_error("Failed to get media folder list: HTTP " .. tostring(code))
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
        setPatchDouble(path, frame)
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
setInitializing("Connecting...")
if fn_check_valid_ip(ip_address) then
  Connect(ip_address, fn_hive_connect_Status)
  fn_log_message("Connecting to Hive player at " .. ip_address)
else
  setMissing("Invalid IP")
  fn_log_error("Invalid IP address: " .. ip_address)
end
