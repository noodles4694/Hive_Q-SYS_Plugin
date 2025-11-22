-- Set up event handlers for controls
fn_log_debug("Setting up control event handlers")
for i = 1, layer_count do
  Controls["file_select_" .. i].EventHandler = function()
    cmd_file_select(i, file_list[Controls["file_select_" .. i].String])
  end
  Controls["folder_select_" .. i].EventHandler = function()
    cmd_folder_select(i, folder_list[Controls["folder_select_" .. i].String])
  end
  Controls["file_select_index_" .. i].EventHandler = function()
    cmd_file_select(i, Controls["file_select_index_" .. i].Value)
  end
  Controls["folder_select_index_" .. i].EventHandler = function()
    cmd_folder_select(i, Controls["folder_select_index_" .. i].Value)
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
  Controls["play_mode_index_" .. i].EventHandler = function()
    cmd_play_mode(i, Controls["play_mode_index_" .. i].Value)
  end
  Controls["framing_mode_" .. i].EventHandler = function()
    local val = get_table_value(framing_mode_keys, framing_mode_values, Controls["framing_mode_" .. i].String)
    cmd_framing(i, val)
  end
  Controls["framing_mode_index_" .. i].EventHandler = function()
    cmd_framing(i, Controls["framing_mode_index_" .. i].Value)
  end
  Controls["blend_mode_" .. i].EventHandler = function()
    local val = get_table_value(blend_mode_keys, blend_mode_values, Controls["blend_mode_" .. i].String)
    cmd_blend_mode(i, val)
  end
  Controls["blend_mode_index_" .. i].EventHandler = function()
    cmd_blend_mode(i, Controls["blend_mode_index_" .. i].Value)
  end
  Controls["fx1_select_" .. i].EventHandler = function()
    local val = get_table_value(fx_keys, fx_values, Controls["fx1_select_" .. i].String)
    cmd_fx1_select(i, val)
  end
  Controls["fx1_select_index_" .. i].EventHandler = function()
    cmd_fx1_select(i, Controls["fx1_select_index_" .. i].Value)
  end
  Controls["fx2_select_" .. i].EventHandler = function()
    local val = get_table_value(fx_keys, fx_values, Controls["fx2_select_" .. i].String)
    cmd_fx2_select(i, val)
  end
  Controls["fx2_select_index_" .. i].EventHandler = function()
    cmd_fx2_select(i, Controls["fx2_select_index_" .. i].Value)
  end
  Controls["lut_" .. i].EventHandler = function()
    cmd_lut_select(i, lut_list[Controls["lut_" .. i].String])
  end
  Controls["lut_index_" .. i].EventHandler = function()
    cmd_lut_select(i, Controls["lut_index_" .. i].Value)
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
  Controls["transition_mode_index_" .. i].EventHandler = function()
    cmd_transition_mode(i, Controls["transition_mode_index_" .. i].Value)
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
Controls["system_wake"].EventHandler = function()
  cmd_wake()
end

Controls["settings_json"].EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_settings_data(Controls["settings_json"].String)
end

Controls["timeline_json"].EventHandler = function()
    if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_timeline_data(Controls["timeline_json"].String)
end

Controls["scheduler_json"].EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_scheduler_data(Controls["scheduler_json"].String)
end

Controls["timecode_json"].EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_timecode_data(Controls["timecode_json"].String)
end

Controls["playlist_json"].EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_playlist_data(Controls["playlist_json"].String)
end
Controls["mapping_json"].EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    fn_log_warning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  cmd_update_mapping_data(Controls["mapping_json"].String)
end

fn_log_debug("Control event handlers set up complete")
