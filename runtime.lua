-- Logic to deal with connection and disconnection of the Hive player
function fn_hive_connect_Status(status)
  fn_log_debug("Setting connected status to " .. tostring(status))
  if status == true then
    Controls.online.Boolean = true

    fn_watch_parameters()
    fn_update_info()
    fn_poll_info()
    fn_update_media_folders()
    fn_fetch_video_previews()
  else
    Controls.online.Boolean = false
    Controls.status.String = "Offline"
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
  watchPatchDouble("/Playlist Control/Playlist Controller 1/Row Index", fn_process_playlist_row_update)
  -- get the LUT options and update controls
  -- set the RAW mode so we can parse the raw data manually
  getPatchJSON("/LUT Colour Modes", fn_process_LUT_data, true)
  fn_log_debug("LUT options requested")
  watchPatchString(
    "/Status/Text",
    function(path, value)
      Controls.activity.String = value
    end
  )

  -- Watch for value changes in layer parameters
  fn_log_debug("Setting up layer parameter watchers")
  for i = 1, layer_count do
    for _, parameter in ipairs(poll_parameter_list) do
      local path = string.format("/LAYER %s/%s/Value", i, parameter)
      watchPatchDouble(path, fn_process_double_update)
    end
    for _, parameter in ipairs(fx1_list) do
      local path = string.format("/LAYER %s/%s/Value", i, parameter:upper())
      watchPatchDouble(path, fn_process_double_update)
    end
    for _, parameter in ipairs(fx2_list) do
      local path = string.format("/LAYER %s/%s/Value", i, parameter:upper())
      watchPatchDouble(path, fn_process_double_update)
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
        Controls.engine_fps.String = value
      end
    )
    fn_update_sync_status()
  end
  if wsConnected then
    Timer.CallAfter(fn_poll_info, 1)
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
        Controls.sync_status.String = info.status
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
  -- this is a bit hacky but it works
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
        Controls["lut_" .. i].Choices = lut_choices
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
    local currentFileName = file_list_names[selected_file[tonumber(layer)]] or ""
    if sub_parameter == "Media Time" then
      if not seek_timer_list[tonumber(layer)]:IsRunning() then
        if currentFileName == "" or file_metadata_list[currentFileName] == nil or file_metadata_list[currentFileName].duration == 0 then
          Controls["seek_" .. layer].Position = 0
          Controls["time_elapsed_" .. layer].String = os.date("!%X", 0)
        else
          local pos = tonumber(value) / file_metadata_list[currentFileName].duration
          Controls["seek_" .. layer].Position = pos
          Controls["time_elapsed_" .. layer].String = os.date("!%X", math.floor(value))
        end
      end
    end
  else
    fn_log_error("Unknown transport parameter: " .. parameter)
  end
end

-- Handle playlist row updates from the Hive player
function fn_process_playlist_row_update(path, value)
  fn_log_debug("Playlist active row updated to " .. tostring(value + 1))
  playlist_active_row = value + 1 -- convert from 0 based to 1 based
  Controls.playlist_current_row.Value = playlist_active_row
end

-- Handle double updates from the Hive player
function fn_process_double_update(path, value)
  fn_log_debug("Processing double update: " .. path .. " = " .. tostring(value))
  if path:sub(1, 6) == "/LAYER" then -- Layer parameter response
    local layer, parameter = path:match("/LAYER (%d+)/(%P+)/Value")
    if parameter then
      local control = string.format("%s_%s", parameter:gsub("%s", "_"):lower(), layer)
      if parameter == "FILE SELECT" then
        selected_file[tonumber(layer)] = value
        fn_update_selected_file_info(value, layer)
      elseif parameter == "FOLDER SELECT" then
        for k, v in pairs(folder_list) do
          if v == value then
            Controls[control].String = k
            break
          end
        end
      elseif parameter == "LUT" then
        for k, v in pairs(lut_list) do
          if v == value then
            Controls[control].String = k
            break
          end
        end
      elseif parameter:sub(-5, -1) == "FRAME" then
        Controls[control].Value = value
      elseif parameter == "PLAY MODE" then
        local key = get_table_key(play_mode_keys, play_mode_values, value)
        Controls[control].String = key
      elseif parameter == "FRAMING MODE" then
        local key = get_table_key(framing_mode_keys, framing_mode_values, value)
        Controls[control].String = key
      elseif parameter == "BLEND MODE" then
        local key = get_table_key(blend_mode_keys, blend_mode_values, value)
        Controls[control].String = key
      elseif parameter == "TRANSITION MODE" then
        local key = get_table_key(transition_mode_keys, transition_mode_values, value)
        Controls[control].String = key
      elseif parameter == "FX1 SELECT" then
        local key = get_table_key(fx_keys, fx_values, value)
        Controls[control].String = key
      elseif parameter == "FX2 SELECT" then
        local key = get_table_key(fx_keys, fx_values, value)
        Controls[control].String = key
      elseif parameter == "PLAY SPEED" or parameter == "SCALE" then
        if value >= 0.5 then
          Controls[control].Position = (value - 0.4444444444444444) / 0.5555555555555556
        else
          Controls[control].Position = value / 5
        end
      elseif parameter:sub(1, 3) == "MTC" then
        Controls[control].Value = value
      elseif parameter:sub(1, 8) == "POSITION" then
        Controls[control].Value = (value * 200) - 100
      elseif parameter:sub(1, 8) == "ROTATION" then
        Controls[control].Value = (value * 2880) - 1440
      elseif parameter:sub(1, 19) == "TRANSITION DURATION" then
        Controls[control].Value = value
      elseif
        parameter == "RED" or parameter == "BLUE" or parameter == "GREEN" or parameter == "SATURATION" or
          parameter == "CONTRAST"
       then
        Controls[control].Value = (value * 200) - 100
      else -- parameters where data directly proportional to position
        Controls[control].Position = value
      end
    else
      fn_log_error("Unknown layer parameter: " .. path)
    end
  end
end

function fn_update_selected_file_info(value, layer)
  local found = false
  for media = 1, media_item_count do
    Controls[string.format("media_thumbnail_%s_layer_%s", media, layer)].Boolean = media == (value + 1)
  end
  local currentFileName = file_list_names[value] or ""
      fn_update_preview_thumbnail(layer, currentFileName)
      Controls[string.format("file_select_%s", layer)].String = currentFileName
      if file_metadata_list[currentFileName] then
        Controls["duration_" .. layer].String = os.date("!%X", math.floor(file_metadata_list[currentFileName].duration)) 
      else
        Controls["duration_" .. layer].String = os.date("!%X", 0)
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
      Controls[string.format("media_name_%s_layer_%s", m, i)].String = ""
      Controls[string.format("media_thumbnail_%s_layer_%s", m, i)].Style = iconStyleBlankString
    end
  end
end

-- Handle JSON updates from the Hive player
function fn_process_JSON_update(path, value)
  fn_log_debug("Processing JSON update: " .. path)
  if path == "/System Settings" then
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
        if Controls[string.format("media_name_%s_layer_%s", file.fileIndex, i)] then
          Controls[string.format("media_name_%s_layer_%s", file.fileIndex, i)].String = file.name
        end
      end
      fn_get_file_thumbnail(file.fileIndex, file.name)
    end
    for i = 1, layer_count do
      Controls["file_select_" .. i].Choices = file_choice_list
       fn_update_selected_file_info(selected_file[i],i)
    end
    -- let's update the system info as storage and num files might have changed
    fn_update_info()
  elseif path == "/Output Mapping" then
  elseif path == "/Play List" then
    fn_log_debug(
      "Playlist updated, total items: " ..
        tostring(value.list and #value.list or 0) .. ", enabled: " .. tostring(value.usePlayList)
    )
    if value.usePlayList and value.usePlayList == 1 then
      Controls.playlist_enable.Boolean = true
    else
      Controls.playlist_enable.Boolean = false
    end
    playlist_row_count = value.list and #value.list or 0
    Controls.playlist_rows.Value = playlist_row_count
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
    if value.layers[1] and value.layers[1].useCueList == 1 then
      Controls.l1_timecode_enable.Boolean = true
    else
      Controls.l1_timecode_enable.Boolean = false
    end
    if value.layers[2] and value.layers[2].useCueList == 1 then
      Controls.l2_timecode_enable.Boolean = true
    else
      Controls.l2_timecode_enable.Boolean = false
    end
    Controls.l1_tc_rows.Value = value.layers[1] and #(value.layers[1].list) or 0
    Controls.l2_tc_rows.Value = value.layers[2] and #(value.layers[2].list) or 0
  elseif path == "/Schedule" then
    fn_log_debug("Schedule updated, enabled: " .. tostring(value.useSchedule))
    if value.useSchedule and value.useSchedule == 1 then
      Controls.schedule_enable.Boolean = true
    else
      Controls.schedule_enable.Boolean = false
    end
  elseif path == "/Timeline" then
    fn_log_debug("Timeline updated, enabled: " .. tostring(value.useTimeline))
    if value.useTimeline and value.useTimeline == 1 then
      Controls.timeline_enable.Boolean = true
    else
      Controls.timeline_enable.Boolean = false
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
        Controls.version.String = info.hiveVersion

        if info and info.tileList then
          local device = nil
          for _, tile in ipairs(info.tileList) do
            if fn_compare_ips(tile.ipAddress, ip_address) then
              device = tile
              break
            end
          end
          if device then
            Controls.device_name.String = device.deviceName
            Controls.ip_address.String = device.ipAddress
            Controls.netmask.String = device.netMask
            Controls.status.String = device.status
            Controls.output_framerate.String = device.rate
            Controls.output_resolution.String = string.format("%s x %s", device.resX, device.resY)
            Controls.serial.String = device.serial
            Controls.bee_type.String = (device.beeType == 1) and "Queen" or "Worker"
            Controls.file_count.String = device.nFiles
            Controls.cpu_power.String = device.power
            Controls.free_space.String = string.format("%.2f GB", tonumber(device.space) / (1024 * 1024 * 1024))
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
            Controls[string.format("media_thumbnail_%s_layer_%s", index, i)].Style = rapidjson.encode(iconStyle)
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
      --Padding = -16,
      --Margin = 0,
      IconData = ""
    }
    local iconStyleBlankString = rapidjson.encode(iconStyleBlank)
    Controls[string.format("layer_%s_preview", layer)].Style = iconStyleBlankString
    if tonumber(layer) == 1 and Properties["Output Video Preview"].Value == "Disabled" then
      Controls["output_preview"].Style = iconStyleBlankString
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
          --HorizontalAlignment = "Center",
          Legend = "",
         -- Padding = -16,
          --Margin = 0,
          IconData = Qlib.base64_enc(data)
        }
        Controls[string.format("layer_%s_preview", layer)].Style = rapidjson.encode(iconStyle)
        if tonumber(layer) == 1 and Properties["Output Video Preview"].Value == "Disabled" then
          Controls["output_preview"].Style = rapidjson.encode(iconStyle)
        end
      end
    end
  }
end
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
  if Properties["Output Video Preview"].Value == "Disabled" then
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
         -- HorizontalAlignment = "Center",
          Legend = "",
         -- Padding = -16,
         -- Margin = 0,
          IconData = frameData.imgDataMapped
        }
        Controls["output_preview"].Style = rapidjson.encode(iconStyle)
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
          Controls["folder_select_" .. i].Choices = folder_choices
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
    if Controls[string.format("seek_%s", layer)].String == seek_last_value[layer] then
      if Controls["file_select_" .. layer].String ~= "" then
        local frame =
          math.floor(
          file_metadata_list[Controls["file_select_" .. layer].String].duration *
            file_metadata_list[Controls["file_select_" .. layer].String].rate *
            Controls["seek_" .. layer].Position
        )
        -- Seek to desired frame
        local path = string.format("/LAYER %s/Transport Control/MediaClockGenerator/Seek", layer)
        setPatchDouble(path, frame)
      end
      seek_timer_list[layer]:Stop()
    end
    seek_last_value[layer] = Controls[string.format("seek_%s", layer)].String
  end
end

-- Initialize combobox choices
for i = 1, layer_count do
  Controls["play_mode_" .. i].Choices = play_mode_keys
  Controls["framing_mode_" .. i].Choices = framing_mode_keys
  Controls["blend_mode_" .. i].Choices = blend_mode_keys
  Controls["transition_mode_" .. i].Choices = transition_mode_keys
  Controls["fx1_select_" .. i].Choices = fx_keys
  Controls["fx2_select_" .. i].Choices = fx_keys
end

-- Connect
if fn_check_valid_ip(ip_address) then
  fn_log_message("Connecting to Hive player at " .. ip_address)
  Connect(ip_address, fn_hive_connect_Status)
else
  fn_log_error("Invalid IP address: " .. ip_address)
end
