-- Set up event handlers for controls
fn_log_debug("Setting up control event handlers")
for i = 1, layer_count do
  Controls["FileSelect " .. i].EventHandler = function()
    cmd_file_select(i, file_list[Controls["FileSelect " .. i].String])
  end
  Controls["FolderSelect " .. i].EventHandler = function()
    cmd_folder_select(i, folder_list[Controls["FolderSelect " .. i].String])
  end
  Controls["FileSelectIndex " .. i].EventHandler = function()
    cmd_file_select(i, Controls["FileSelectIndex " .. i].Value)
  end
  Controls["FolderSelectIndex " .. i].EventHandler = function()
    cmd_folder_select(i, Controls["FolderSelectIndex " .. i].Value)
  end
  Controls["Intensity " .. i].EventHandler = function()
    cmd_intensity(i, Controls["Intensity " .. i].Position)
  end
  Controls["InFrame " .. i].EventHandler = function()
    cmd_in_frame(i, Controls["InFrame " .. i].Value)
  end
  Controls["OutFrame " .. i].EventHandler = function()
    cmd_out_frame(i, Controls["OutFrame " .. i].Value)
  end
  Controls["PlayMode " .. i].EventHandler = function()
    local val = get_table_value(play_mode_keys, play_mode_values, Controls["PlayMode " .. i].String)
    cmd_play_mode(i, val)
  end
  Controls["PlayModeIndex " .. i].EventHandler = function()
    cmd_play_mode(i, Controls["PlayModeIndex " .. i].Value)
  end
  Controls["FramingMode " .. i].EventHandler = function()
    local val = get_table_value(framing_mode_keys, framing_mode_values, Controls["FramingMode " .. i].String)
    cmd_framing(i, val)
  end
  Controls["FramingModeIndex " .. i].EventHandler = function()
    cmd_framing(i, Controls["FramingModeIndex " .. i].Value)
  end
  Controls["BlendMode " .. i].EventHandler = function()
    local val = get_table_value(blend_mode_keys, blend_mode_values, Controls["BlendMode " .. i].String)
    cmd_blend_mode(i, val)
  end
  Controls["BlendModeIndex " .. i].EventHandler = function()
    cmd_blend_mode(i, Controls["BlendModeIndex " .. i].Value)
  end
  Controls["FX1Select" .. i].EventHandler = function()
    local val = get_table_value(fx_keys, fx_values, Controls["FX1Select" .. i].String)
    cmd_fx1_select(i, val)
  end
  Controls["FX1SelectIndex " .. i].EventHandler = function()
    cmd_fx1_select(i, Controls["FX1SelectIndex " .. i].Value)
  end
  Controls["FX2Select " .. i].EventHandler = function()
    local val = get_table_value(fx_keys, fx_values, Controls["FX2Select " .. i].String)
    cmd_fx2_select(i, val)
  end
  Controls["FX2SelectIndex " .. i].EventHandler = function()
    cmd_fx2_select(i, Controls["FX2SelectIndex " .. i].Value)
  end
  Controls["Lut " .. i].EventHandler = function()
    cmd_lut_select(i, lut_list[Controls["Lut " .. i].String])
  end
  Controls["LutIndex " .. i].EventHandler = function()
    cmd_lut_select(i, Controls["LutIndex " .. i].Value)
  end
  Controls["PlaySpeed " .. i].EventHandler = function()
    local converted_value = Controls["PlaySpeed " .. i].Position
    if Controls["PlaySpeed " .. i].Position >= 0.1 then
      converted_value = 0.5555555555555556 * Controls["PlaySpeed " .. i].Position + 0.4444444444444444
    else
      converted_value = 5 * Controls["PlaySpeed " .. i].Position
    end
    cmd_play_speed(i, converted_value)
  end
  Controls["MoveSpeed " .. i].EventHandler = function()
    cmd_movement_speed(i, Controls["MoveSpeed " .. i].Position)
  end
  Controls["MtcHour " .. i].EventHandler = function()
    cmd_tc_hour(i, Controls["MtcHour " .. i].Value)
  end
  Controls["MtcMinute " .. i].EventHandler = function()
    cmd_tc_minute(i, Controls["MtcMinute " .. i].Value)
  end
  Controls["MtcSecond " .. i].EventHandler = function()
    cmd_tc_second(i, Controls["MtcSecond " .. i].Value)
  end
  Controls["MtcFrame " .. i].EventHandler = function()
    cmd_tc_frame(i, Controls["MtcFrame " .. i].Value)
  end
  Controls["Scale " .. i].EventHandler = function()
    local converted_value = Controls["Scale " .. i].Position
    if Controls["Scale " .. i].Position >= 0.1 then
      converted_value = 0.5555555555555556 * Controls["Scale " .. i].Position + 0.4444444444444444
    else
      converted_value = 5 * Controls["Scale " .. i].Position
    end
    cmd_scale(i, converted_value)
  end
  Controls["AspectRatio " .. i].EventHandler = function()
    cmd_aspect_ratio(i, Controls["AspectRatio " .. i].Position)
  end
  Controls["PositionX " .. i].EventHandler = function()
    cmd_position_x(i, (Controls["PositionX " .. i].Value + 100) / 200)
  end
  Controls["PositionY " .. i].EventHandler = function()
    cmd_position_y(i, (Controls["PositionY " .. i].Value + 100) / 200)
  end
  Controls["RotationX " .. i].EventHandler = function()
    cmd_rotation_x(i, (Controls["RotationX " .. i].Value + 1440) / 2880)
  end
  Controls["RotationY " .. i].EventHandler = function()
    cmd_rotation_y(i, (Controls["RotationY " .. i].Value + 1440) / 2880)
  end
  Controls["RotationZ " .. i].EventHandler = function()
    cmd_rotation_z(i, (Controls["RotationZ " .. i].Value + 1440) / 2880)
  end
  Controls["Red " .. i].EventHandler = function()
    cmd_red(i, (Controls["Red " .. i].Value + 100) / 200)
  end
  Controls["Green " .. i].EventHandler = function()
    cmd_green(i, (Controls["Green " .. i].Value + 100) / 200)
  end
  Controls["Blue " .. i].EventHandler = function()
    cmd_blue(i, (Controls["Blue " .. i].Value + 100) / 200)
  end
  Controls["Hue " .. i].EventHandler = function()
    cmd_hue(i, Controls["Hue " .. i].Position)
  end
  Controls["Saturation " .. i].EventHandler = function()
    cmd_saturation(i, (Controls["Saturation " .. i].Value + 100) / 200)
  end
  Controls["Contrast " .. i].EventHandler = function()
    cmd_contrast(i, (Controls["Contrast " .. i].Value + 100) / 200)
  end
  Controls["Strobe " .. i].EventHandler = function()
    cmd_strobe(i, Controls["Strobe " .. i].Position)
  end
  Controls["Volume " .. i].EventHandler = function()
    cmd_volume(i, Controls["Volume " .. i].Position)
  end
  Controls["Seek " .. i].EventHandler = function()
    seek_timer_list[i]:Start(.2)
  end
  Controls["TransitionDuration " .. i].EventHandler = function()
    cmd_transition_duration(i, Controls["TransitionDuration " .. i].Value)
  end
  Controls["TransitionMode " .. i].EventHandler = function()
    local val = get_table_value(transition_mode_keys, transition_mode_values, Controls["TransitionMode " .. i].String)
    cmd_transition_mode(i, val)
  end
  Controls["TransitionModeIndex " .. i].EventHandler = function()
    cmd_transition_mode(i, Controls["TransitionModeIndex " .. i].Value)
  end
  Controls["FX1Opacity " .. i].EventHandler = function()
    _G["cmd_fx1_opacity"](i, Controls["FX1Opacity " .. i].Position)
  end
  Controls["FX2Opacity " .. i].EventHandler = function()
    _G["cmd_fx2_opacity"](i, Controls["FX2Opacity " .. i].Position)
  end
  for p = 1, 16 do
    Controls[string.format("FX1Param%s %s", p, i)].EventHandler = function()
      _G["cmd_fx1_param_" .. p](i, Controls[string.format("FX1Param%s %s", p, i)].Position)
    end
    Controls[string.format("FX2Param%s %s", p, i)].EventHandler = function()
      _G["cmd_fx2_param_" .. p](i, Controls[string.format("FX2Param%s %s", p, i)].Position)
    end
  end

  for p = 1, media_item_count do
    Controls[string.format("MediaThumbnail%s %s", p, i)].EventHandler = function()
      if Controls[string.format("MediaName%s %s", p, i)].String ~= nil then
        cmd_file_select(i, file_list[Controls[string.format("MediaName%s %s", p, i)].String])
      end
    end
  end
end

Controls.PlaylistEnable.EventHandler = function()
  cmd_enable_playlist(Controls.PlaylistEnable.Boolean and 1 or 0)
end
Controls.TimelineEnable.EventHandler = function()
  cmd_enable_timeline(Controls.TimelineEnable.Boolean and 1 or 0)
end
Controls.ScheduleEnable.EventHandler = function()
  cmd_enable_schedule(Controls.ScheduleEnable.Boolean and 1 or 0)
end
Controls.L1TimecodeEnable.EventHandler = function()
  cmd_enable_tc1(Controls.L1TimecodeEnable.Boolean and 1 or 0)
end
Controls.L2TimecodeEnable.EventHandler = function()
  cmd_enable_tc2(Controls.L2TimecodeEnable.Boolean and 1 or 0)
end
Controls.PlaylistPlayPrevious.EventHandler = function()
  cmd_playlist_play_previous()
end
Controls.PlaylistPlayNext.EventHandler = function()
  cmd_playlist_play_next()
end
Controls.PlaylistPlayFirst.EventHandler = function()
  cmd_playlist_play_first()
end
Controls.PlaylistPlayLast.EventHandler = function()
  cmd_playlist_play_last()
end
Controls.PlaylistPlayRow.EventHandler = function()
  if Controls.PlaylistPlayRowIndex.String ~= "" then
    local row = tonumber(Controls.PlaylistPlayRowIndex.String)
    if row then
      cmd_playlist_play_row(row)
    end
  end
end
Controls.SystemShutdown.EventHandler = function()
  cmd_shutdown()
end
Controls.SystemRestart.EventHandler = function()
  cmd_restart()
end
Controls.SystemWake.EventHandler = function()
  cmd_wake()
end

Controls.SettingsJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_settings_data(Controls.SettingsJSON.String)
end

Controls.TimelineJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_timeline_data(Controls.TimelineJSON.String)
end

Controls.SchedulerJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_scheduler_data(Controls.SchedulerJSON.String)
end

Controls.TimecodeJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_timecode_data(Controls.TimecodeJSON.String)
end

Controls.PlaylistJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_playlist_data(Controls.PlaylistJSON.String)
end
Controls.MappingJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_mapping_data(Controls.MappingJSON.String)
end

fn_log_debug("Control event handlers set up complete")
