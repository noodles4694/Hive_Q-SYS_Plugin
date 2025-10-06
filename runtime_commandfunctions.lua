-- Command functions called by control callbacks
function cmd_file_select(layer, x) -- 0..65535: File Select
  local currentFileName = file_list_names[selected_file[layer] + 1] or "None"
  if file_metadata_list[currentFileName] then
    Controls["duration_" .. layer].String = os.date("!%X", math.floor(file_metadata_list[currentFileName].duration))
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
