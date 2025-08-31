---checks if a string represents an ip address
function fn_check_valid_ip(ip)
  if not ip then
    return false
  end
  local a, b, c, d = ip:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)$")
  a = tonumber(a)
  b = tonumber(b)
  c = tonumber(c)
  d = tonumber(d)
  if not a or not b or not c or not d then
    return false
  end
  if a < 0 or 255 < a then
    return false
  end
  if b < 0 or 255 < b then
    return false
  end
  if c < 0 or 255 < c then
    return false
  end
  if d < 0 or 255 < d then
    return false
  end
  return true
end

function fn_hive_connect_Status(status)
  if status == true then
    Controls.online.Boolean = true
    fn_watch_parameters()
    fn_update_info()
  else
    Controls.online.Boolean = false
  end
end

function fn_watch_parameters()
  -- Watch for JSON updates
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

  watchPatchString(
    "/Status/Text",
    function(path, value)
      Controls.activity.String = value
    end
  )

  -- Watch for value changes in layer parameters
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
  for i = 1, layer_count do
    watchPatchDouble(string.format("/LAYER %s/Transport Control/Media Time/Value", i), fn_process_transport_update)
  end
end

function fn_poll_info()
  getPatchString(
    "/Mapping/Render Resolution/FPS",
    function(path, value)
      Controls.engine_fps.String = value
    end
  )
  fn_update_sync_status()
  Timer.CallAfter(fn_poll_info, 1)
end

function fn_update_sync_status()
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
        Controls.sync_status.String = info.status
      end
    end
  }
end

function fn_send(layer, cmd, val)
  local path = "/LAYER " .. layer .. "/" .. cmd .. "/Value" -- please make this neater with string.format()
  setPatchDouble(path, val)
end

function fn_send_json(cmd, val)
  local path = "/" .. cmd
  setPatchJSON(path, val)
end

function fn_update_json(cmd, val)
  local path = "/" .. cmd
  updatePatchJSON(path, val)
end

function fn_process_LUT_data(path, data)
  -- The LUT list is inside a JSON object under the "Value" key
  -- however it is not indexed so we have to extract the string pairs manually
  -- in order to maintain the ordering
  -- this is a bit hacky but it works

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
  end
end

function fn_process_transport_update(path, value)
  local layer, parameter = path:match("/LAYER (%d+)/(%P+)")
  if parameter == "Transport Control" then
    local layer, parameter, sub_parameter = path:match("/LAYER (%d+)/(%P+)/(%P+)")
    if sub_parameter == "Media Time" then
      if Controls["file_select_" .. layer].String ~= "" and not seek_timer_list[tonumber(layer)]:IsRunning() then
        if file_metadata_list[Controls["file_select_" .. layer].String].duration == 0 then
          Controls["seek_" .. layer].Position = 0
          Controls["time_elapsed_" .. layer].String = os.date("!%X", 0)
        else
          local pos = tonumber(value) / file_metadata_list[Controls["file_select_" .. layer].String].duration
          Controls["seek_" .. layer].Position = pos
          Controls["time_elapsed_" .. layer].String = os.date("!%X", math.floor(value))
        end
      end
    end
  end
end

function fn_process_playlist_row_update(path, value)
  playlist_active_row = value + 1 -- convert from 0 based to 1 based
  Controls.playlist_current_row.Value = playlist_active_row
end

function fn_process_double_update(path, value)
  if path:sub(1, 6) == "/LAYER" then -- Layer parameter response
    local layer, parameter = path:match("/LAYER (%d+)/(%P+)/Value")
    if parameter then
      local control = string.format("%s_%s", parameter:gsub("%s", "_"):lower(), layer)
      if parameter == "FILE SELECT" then
        for k, v in pairs(file_list) do
          if v == value then
            Controls[control].String = k
            Controls["duration_" .. control:sub(-1, -1)].String =
              os.date("!%X", math.floor(file_metadata_list[k].duration))
            for media = 1, media_item_count do
              Controls[string.format("media_thumbnail_%s_layer_%s", media, layer)].Boolean =
                Controls[control].String == Controls[string.format("media_name_%s_layer_%s", media, layer)].String
            end
            break
          end
        end
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
    end
  end
end

function fn_process_JSON_update(path, value)
  if path == "/System Settings" then
    fn_update_info()
  elseif path == "/Media List" then
    local file_choice_list = {}
    for _, file in ipairs(value.files) do
      file_list[file.name] = file.fileIndex - 1
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
    end
    -- let's update the system info as storage and num files might have changed
    fn_update_info()
  elseif path == "/Output Mapping" then
  elseif path == "/Play List" then
    if value.usePlayList and value.usePlayList == 1 then
      Controls.playlist_enable.Boolean = true
    else
      Controls.playlist_enable.Boolean = false
    end
    playlist_row_count = value.list and #value.list or 0
    Controls.playlist_rows.Value = playlist_row_count
  elseif path == "/Timecode Cue List" then
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
    if value.useSchedule and value.useSchedule == 1 then
      Controls.schedule_enable.Boolean = true
    else
      Controls.schedule_enable.Boolean = false
    end
  elseif path == "/Timeline" then
    if value.useTimeline and value.useTimeline == 1 then
      Controls.timeline_enable.Boolean = true
    else
      Controls.timeline_enable.Boolean = false
    end
  elseif path == "/Vioso WB Settings" then
  elseif path == "/Screenberry WB Settings" then
  end
end

function fn_update_info()
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
      end
    end
  }
end

-- compares two ip addresses, ignoring leading zeros
function fn_compare_ips(ip1, ip2)
  local function normalize(ip)
    local parts = {}
    if not ip then
      return ""
    end
    for octet in string.gmatch(ip, "%d+") do
      table.insert(parts, tostring(tonumber(octet))) -- remove leading zeros
    end
    return table.concat(parts, ".")
  end
  return normalize(ip1) == normalize(ip2)
end

function fn_get_file_thumbnail(index, filename)
  if index <= media_item_count then
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
  end
end

function fn_update_media_folders()
  url = string.format("http://%s/api/getMediaFoldersList", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode({}), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
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
      end
    end
  }
end

function cmd_file_select(layer, x) -- 0..65535: File Select
  if file_metadata_list[Controls["file_select_" .. layer].String] then
    Controls["duration_" .. layer].String =
      os.date("!%X", math.floor(file_metadata_list[Controls["file_select_" .. layer].String].duration))
    fn_send(layer, "FILE SELECT", x)
  end
end

function cmd_folder_select(layer, x) -- 0..65535: Folder Select
  fn_send(layer, "FOLDER SELECT", x)
end

function cmd_intensity(layer, x)
  fn_send(layer, "INTENSITY", x)
end

function cmd_in_frame(layer, x)
  fn_send(layer, "IN FRAME", x)
end

function cmd_out_frame(layer, x)
  fn_send(layer, "OUT FRAME", x)
end

function cmd_play_mode(layer, x)
  fn_send(layer, "PLAY MODE", x)
end

function cmd_framing(layer, x)
  fn_send(layer, "FRAMING MODE", x)
end

function cmd_blend_mode(layer, x)
  fn_send(layer, "BLEND MODE", x)
end

function cmd_lut_select(layer, x)
  fn_send(layer, "LUT", x)
end

function cmd_play_speed(layer, x)
  fn_send(layer, "PLAY SPEED", x)
end

function cmd_movement_speed(layer, x)
  fn_send(layer, "MOVEMENT SPEED", x)
end

function cmd_tc_hour(layer, x)
  fn_send(layer, "MTC HOUR", x)
end

function cmd_tc_minute(layer, x)
  fn_send(layer, "MTC MINUTE", x)
end

function cmd_tc_second(layer, x)
  fn_send(layer, "MTC SECOND", x)
end

function cmd_tc_frame(layer, x)
  fn_send(layer, "MTC FRAME", x)
end

function cmd_scale(layer, x)
  fn_send(layer, "SCALE", x)
end

function cmd_aspect_ratio(layer, x)
  fn_send(layer, "ASPECT RATIO", x)
end

function cmd_position_x(layer, x)
  fn_send(layer, "POSITION X", x)
end

function cmd_position_y(layer, x)
  fn_send(layer, "POSITION Y", x)
end

function cmd_rotation_x(layer, x)
  fn_send(layer, "ROTATION X", x)
end

function cmd_rotation_y(layer, x)
  fn_send(layer, "ROTATION Y", x)
end

function cmd_rotation_z(layer, x)
  fn_send(layer, "ROTATION Z", x)
end

function cmd_red(layer, x)
  fn_send(layer, "RED", x)
end

function cmd_green(layer, x)
  fn_send(layer, "GREEN", x)
end

function cmd_blue(layer, x)
  fn_send(layer, "BLUE", x)
end

function cmd_hue(layer, x)
  fn_send(layer, "HUE", x)
end

function cmd_saturation(layer, x)
  fn_send(layer, "SATURATION", x)
end

function cmd_contrast(layer, x)
  fn_send(layer, "CONTRAST", x)
end

function cmd_strobe(layer, x)
  fn_send(layer, "STROBE", x)
end

function cmd_volume(layer, x)
  fn_send(layer, "VOLUME", x)
end

function cmd_transition_duration(layer, x)
  fn_send(layer, "TRANSITION DURATION", x)
end

function cmd_transition_mode(layer, x)
  fn_send(layer, "TRANSITION MODE", x)
end

function cmd_enable_playlist(x)
  fn_update_json("Play List", {{op = "replace", path = "/usePlayList", value = x}})
end

function cmd_enable_timeline(x)
  fn_update_json("Timeline", {{op = "replace", path = "/useTimeline", value = x}})
end

function cmd_enable_schedule(x)
  fn_update_json("Schedule", {{op = "replace", path = "/useSchedule", value = x}})
end

function cmd_enable_tc1(x)
  fn_update_json("Timecode Cue List", {{op = "replace", path = "/layers/0/useCueList", value = x}})
end

function cmd_enable_tc2(x)
  fn_update_json("Timecode Cue List", {{op = "replace", path = "/layers/1/useCueList", value = x}})
end

function cmd_playlist_play_previous()
  if playlist_row_count > 0 then
    local new_row = playlist_active_row - 1
    if new_row < 1 then
      new_row = playlist_row_count
    end
    setPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function cmd_playlist_play_next()
  if playlist_row_count > 0 then
    local new_row = playlist_active_row + 1
    if new_row > playlist_row_count then
      new_row = 1
    end
    setPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function cmd_playlist_play_first()
  if playlist_row_count > 0 then
    local new_row = 1
    setPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function cmd_playlist_play_last()
  if playlist_row_count > 0 then
    local new_row = playlist_row_count
    setPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function cmd_playlist_play_row(x)
  if playlist_row_count > 0 then
    local new_row = x
    if new_row < 1 then
      new_row = 1
    end
    if new_row > playlist_row_count then
      new_row = playlist_row_count
    end
    setPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function cmd_restart()
  local url = string.format("http://%s/api/runSystemCommand", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode(
      {
        method = "Nectar_run_command",
        cmd = "sudo reboot"
      }
    ), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        print("Restart command sent")
      end
    end
  }
end

function cmd_shutdown()
  local url = string.format("http://%s/api/runSystemCommand", ip_address)
  HttpClient.Post {
    Url = url,
    Data = rapidjson.encode(
      {
        method = "Nectar_run_command",
        cmd = "sudo shutdown -h now"
      }
    ), -- This can be anything
    Headers = {
      ["Content-Type"] = "application/json"
    },
    EventHandler = function(tbl, code, data, error, headers)
      if code == 200 then
        print("Shutdown command sent")
      end
    end
  }
end

for i = 1, 2 do
  _G["cmd_fx" .. i .. "_select"] = function(layer, x)
    fn_send(layer, "FX" .. i .. " SELECT", x)
  end
  _G["cmd_fx" .. i .. "_opacity"] = function(layer, x)
    fn_send(layer, "FX" .. i .. " OPACITY", x)
  end
  for p = 1, 16 do
    _G["cmd_fx" .. i .. "_param_" .. p] = function(layer, x)
      fn_send(layer, "FX" .. i .. " PARAM " .. p, x)
    end
  end
end

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

for i = 1, layer_count do
  Controls["file_select_" .. i].EventHandler = function()
    cmd_file_select(i, file_list[Controls["file_select_" .. i].String])
  end
  Controls["folder_select_" .. i].EventHandler = function()
    cmd_folder_select(i, folder_list[Controls["folder_select_" .. i].String])
  end
  Controls["intensity_" .. i].EventHandler = function()
    cmd_intensity(i, Controls["intensity_" .. i].Position)
  end
  Controls["in_frame_" .. i].EventHandler = function()
    cmd_in_frame(i, Controls["in_frame_" .. i].Value)
  end
  Controls["out_frame_" .. i].EventHandler = function()
    cmd_out_frame(i, Controls["out_frame_" .. i].Value)
  end
  Controls["play_mode_" .. i].EventHandler = function()
    local val = get_table_value(play_mode_keys, play_mode_values, Controls["play_mode_" .. i].String)
    cmd_play_mode(i, val)
  end
  Controls["framing_mode_" .. i].EventHandler = function()
    local val = get_table_value(framing_mode_keys, framing_mode_values, Controls["framing_mode_" .. i].String)
    cmd_framing(i, val)
  end
  Controls["blend_mode_" .. i].EventHandler = function()
    local val = get_table_value(blend_mode_keys, blend_mode_values, Controls["blend_mode_" .. i].String)
    cmd_blend_mode(i, val)
  end
  Controls["fx1_select_" .. i].EventHandler = function()
    local val = get_table_value(fx_keys, fx_values, Controls["fx1_select_" .. i].String)
    cmd_fx1_select(i, val)
  end
  Controls["fx2_select_" .. i].EventHandler = function()
    local val = get_table_value(fx_keys, fx_values, Controls["fx2_select_" .. i].String)
    cmd_fx2_select(i, val)
  end
  Controls["lut_" .. i].EventHandler = function()
    cmd_lut_select(i, lut_list[Controls["lut_" .. i].String])
  end
  Controls["play_speed_" .. i].EventHandler = function()
    local converted_value = Controls["play_speed_" .. i].Position
    if Controls["play_speed_" .. i].Position >= 0.1 then
      converted_value = 0.5555555555555556 * Controls["play_speed_" .. i].Position + 0.4444444444444444
    else
      converted_value = 5 * Controls["play_speed_" .. i].Position
    end
    cmd_play_speed(i, converted_value)
  end
  Controls["move_speed_" .. i].EventHandler = function()
    -- reserved for future use
    cmd_movement_speed(i, Controls["movement_speed_" .. i].Position)
  end
  Controls["mtc_hour_" .. i].EventHandler = function()
    cmd_tc_hour(i, Controls["mtc_hour_" .. i].Value)
  end
  Controls["mtc_minute_" .. i].EventHandler = function()
    cmd_tc_minute(i, Controls["mtc_minute_" .. i].Value)
  end
  Controls["mtc_second_" .. i].EventHandler = function()
    cmd_tc_second(i, Controls["mtc_second_" .. i].Value)
  end
  Controls["mtc_frame_" .. i].EventHandler = function()
    cmd_tc_frame(i, Controls["mtc_frame_" .. i].Value)
  end
  Controls["scale_" .. i].EventHandler = function()
    local converted_value = Controls["scale_" .. i].Position
    if Controls["scale_" .. i].Position >= 0.1 then
      converted_value = 0.5555555555555556 * Controls["scale_" .. i].Position + 0.4444444444444444
    else
      converted_value = 5 * Controls["scale_" .. i].Position
    end
    cmd_scale(i, converted_value)
  end
  Controls["aspect_ratio_" .. i].EventHandler = function()
    cmd_aspect_ratio(i, Controls["aspect_ratio_" .. i].Position)
  end
  Controls["position_x_" .. i].EventHandler = function()
    cmd_position_x(i, (Controls["position_x_" .. i].Value + 100) / 200)
  end
  Controls["position_y_" .. i].EventHandler = function()
    cmd_position_y(i, (Controls["position_y_" .. i].Value + 100) / 200)
  end
  Controls["rotation_x_" .. i].EventHandler = function()
    cmd_rotation_x(i, (Controls["rotation_x_" .. i].Value + 1440) / 2880)
  end
  Controls["rotation_y_" .. i].EventHandler = function()
    cmd_rotation_y(i, (Controls["rotation_y_" .. i].Value + 1440) / 2880)
  end
  Controls["rotation_z_" .. i].EventHandler = function()
    cmd_rotation_z(i, (Controls["rotation_z_" .. i].Value + 1440) / 2880)
  end
  Controls["red_" .. i].EventHandler = function()
    cmd_red(i, (Controls["red_" .. i].Value + 100) / 200)
  end
  Controls["green_" .. i].EventHandler = function()
    cmd_green(i, (Controls["green_" .. i].Value + 100) / 200)
  end
  Controls["blue_" .. i].EventHandler = function()
    cmd_blue(i, (Controls["blue_" .. i].Value + 100) / 200)
  end
  Controls["hue_" .. i].EventHandler = function()
    cmd_hue(i, Controls["hue_" .. i].Position)
  end
  Controls["saturation_" .. i].EventHandler = function()
    cmd_saturation(i, (Controls["saturation_" .. i].Value + 100) / 200)
  end
  Controls["contrast_" .. i].EventHandler = function()
    cmd_contrast(i, (Controls["contrast_" .. i].Value + 100) / 200)
  end
  Controls["strobe_" .. i].EventHandler = function()
    cmd_strobe(i, Controls["strobe_" .. i].Position)
  end
  Controls["volume_" .. i].EventHandler = function()
    cmd_volume(i, Controls["volume_" .. i].Position)
  end
  Controls["seek_" .. i].EventHandler = function()
    seek_timer_list[i]:Start(.2)
  end
  Controls["transition_duration_" .. i].EventHandler = function()
    cmd_transition_duration(i, Controls["transition_duration_" .. i].Value)
  end
  Controls["transition_mode_" .. i].EventHandler = function()
    local val = get_table_value(transition_mode_keys, transition_mode_values, Controls["transition_mode_" .. i].String)
    cmd_transition_mode(i, val)
  end
  Controls["fx1_opacity_" .. i].EventHandler = function()
    _G["cmd_fx1_opacity"](i, Controls["fx1_opacity_" .. i].Position)
  end
  Controls["fx2_opacity_" .. i].EventHandler = function()
    _G["cmd_fx2_opacity"](i, Controls["fx2_opacity_" .. i].Position)
  end
  for p = 1, 16 do
    Controls[string.format("fx1_param_%s_%s", p, i)].EventHandler = function()
      _G["cmd_fx1_param_" .. p](i, Controls[string.format("fx1_param_%s_%s", p, i)].Position)
    end
    Controls[string.format("fx2_param_%s_%s", p, i)].EventHandler = function()
      _G["cmd_fx2_param_" .. p](i, Controls[string.format("fx2_param_%s_%s", p, i)].Position)
    end
  end

  for p = 1, media_item_count do
    Controls[string.format("media_thumbnail_%s_layer_%s", p, i)].EventHandler = function()
      if Controls[string.format("media_name_%s_layer_%s", p, i)].String ~= nil then
        cmd_file_select(i, file_list[Controls[string.format("media_name_%s_layer_%s", p, i)].String])
      end
    end
  end
end

Controls["playlist_enable"].EventHandler = function()
  cmd_enable_playlist(Controls.playlist_enable.Boolean and 1 or 0)
end
Controls["timeline_enable"].EventHandler = function()
  cmd_enable_timeline(Controls.timeline_enable.Boolean and 1 or 0)
end
Controls["schedule_enable"].EventHandler = function()
  cmd_enable_schedule(Controls.schedule_enable.Boolean and 1 or 0)
end
Controls["l1_timecode_enable"].EventHandler = function()
  cmd_enable_tc1(Controls.l1_timecode_enable.Boolean and 1 or 0)
end
Controls["l2_timecode_enable"].EventHandler = function()
  cmd_enable_tc2(Controls.l2_timecode_enable.Boolean and 1 or 0)
end
Controls["playlist_play_previous"].EventHandler = function()
  cmd_playlist_play_previous()
end
Controls["playlist_play_next"].EventHandler = function()
  cmd_playlist_play_next()
end
Controls["playlist_play_first"].EventHandler = function()
  cmd_playlist_play_first()
end
Controls["playlist_play_last"].EventHandler = function()
  cmd_playlist_play_last()
end
Controls["playlist_play_row"].EventHandler = function()
  if Controls.playlist_play_row_index.String ~= "" then
    local row = tonumber(Controls.playlist_play_row_index.String)
    if row then
      cmd_playlist_play_row(row)
    end
  end
end
Controls["system_shutdown"].EventHandler = function()
  cmd_shutdown()
end
Controls["system_restart"].EventHandler = function()
  cmd_restart()
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

fn_update_media_folders()

-- Connect
if fn_check_valid_ip(ip_address) then
  print("Connecting to Hive player at " .. ip_address)
  Connect(ip_address, fn_hive_connect_Status)
  fn_poll_info()
else
  print("Invalid IP address: " .. ip_address)
end
