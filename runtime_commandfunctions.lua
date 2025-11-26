-- Command functions called by control callbacks
function cmd_file_select(layer, x) -- 0..65535: File Select
  local currentFileName = file_list_names[selected_file[layer] + 1] or "None"
  if file_metadata_list[currentFileName] then
    Controls.Duration[layer].String = os.date("!%X", math.floor(file_metadata_list[currentFileName].duration))
  else
    Controls.Duration[layer].String = os.date("!%X", 0)
  end
  fn_send(layer, "FILE SELECT", x)
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

function cmd_update_settings_data(x)
      fn_log_debug("Updating System Settings JSON data")
  if check_hive_json_data_validity(x, "hive buzz settings list") == false then
    fn_log_error("Not sending invalid System Settings JSON data")
    return
  end
  fn_send_json("System Settings", rapidjson.decode(x))
end

function cmd_update_timeline_data(x)
    fn_log_debug("Updating Timeline JSON data")
  if check_hive_json_data_validity(x, "hive buzz timeline") == false then
    fn_log_error("Not sending invalid Timeline JSON data")
    return
  end
  fn_send_json("Timeline", rapidjson.decode(x))
end

function cmd_update_scheduler_data(x)
  fn_log_debug("Updating Scheduler JSON data")
  if check_hive_json_data_validity(x, "hive buzz schedule") == false then
    fn_log_error("Not sending invalid Scheduler JSON data")
    return
  end
  fn_send_json("Schedule", rapidjson.decode(x))
end

function cmd_update_timecode_data(x)
  fn_log_debug("Updating Timecode Cue List JSON data")
  if check_hive_json_data_validity(x, "hive buzz cue list") == false then
    fn_log_error("Not sending invalid Timecode Cue List JSON data")
    return
  end
  fn_send_json("Timecode Cue List", rapidjson.decode(x))
end

function cmd_update_playlist_data(x)
  fn_log_debug("Updating Output Playlist JSON data")
  if check_hive_json_data_validity(x, "hive buzz play list") == false then
    fn_log_error("Not sending invalid Playlist JSON data")
    return
  end
  fn_send_json("Play List", rapidjson.decode(x))
end

function cmd_update_mapping_data(x)
  fn_log_debug("Updating Output Mapping JSON data")
  if check_hive_json_data_validity(x, "hive buzz mapping region list") == false then
    fn_log_error("Not sending invalid Output Mapping JSON data")
    return
  end
  fn_send_json("Output Mapping", rapidjson.decode(x))
end

function check_hive_json_data_validity(json_string, description)
  -- check it can be encoded as JSON and matches expected description
  local status, result = pcall(rapidjson.decode, json_string)
  if status then
    if result and result.description == description then
      print("Valid " .. description .. " JSON data")
      return true
    else
      print("Invalid " .. description .. " JSON data")
      return false
    end
  else
    print("Invalid " .. description .. " JSON data")
    return false
  end
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
  if wsConnected ~= true then
    return
  end
  fn_log_message("Sending restart command to device")
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
        fn_log_message("Restart command sent")
      else
        fn_log_error("Failed to send restart command: HTTP " .. tostring(code))
      end
    end
  }
end

function cmd_shutdown()
  if wsConnected ~= true then
    return
  end
  fn_log_message("Sending shutdown command to device")
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
        fn_log_message("Shutdown command sent")
      else
        fn_log_error("Failed to send shutdown command: HTTP " .. tostring(code))
      end
    end
  }
end

function cmd_wake()
  fn_log_message("Sending wake command to device")
  local ok, err = wake_on_lan(Properties["MAC Address"].Value)
  if not ok then
    fn_log_error("Failed to send wake command: " .. tostring(err))
  else
    fn_log_message("Wake command sent")
  end
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
