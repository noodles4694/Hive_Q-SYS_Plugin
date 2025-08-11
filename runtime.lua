rapidjson = require("rapidjson")

-- Set up UDP Port
local udp = UdpSocket.New()

function fnPoll()
  cmd_read_system_settings()
  fn_poll_parameters()
  --Timer.CallAfter(cmd_read_media_list, 1)
  --Timer.CallAfter(cmd_read_play_list, 2)
  --Timer.CallAfter(cmd_read_timecode_cue_list, 3)
  --Timer.CallAfter(cmd_read_output_mapping, 4)
  -- Timer.CallAfter(fnPoll, 0.2)
end

function fn_poll_parameters()
  for i = 1, layer_count do
    fn_get(i, poll_parameter_list[ticker])
  end
  if ticker > #poll_parameter_list - 1 then
    ticker = 1
    cmd_read_media_list()
  else
    ticker = ticker + 1
  end
end

function fn_poll_transport()
  for i = 1, layer_count do
    fn_get(i, "Transport Control/Media Time")
  end
  -- Timer.CallAfter(fn_poll_transport, 1)
end

function noResponse()
  Controls.online.Boolean = false
end

function still_alive()
  Controls.online.Boolean = true
  feedbackChecker:Stop()
  feedbackChecker:Start(11)
end

feedbackChecker = Timer.New()
feedbackChecker.EventHandler = noResponse

function fn_send(layer, cmd, val)
  local send_string = udp_command_base_string_set .. layer .. "/" .. cmd .. '/Value", ' .. val .. ")" -- please make this neater with string.format()
  --print(send_string)
  udp:Send(ip_address, udp_port, send_string)
end

function fn_get(layer, cmd)
  local send_string = udp_command_base_string_get .. layer .. "/" .. cmd .. '/Value", UDPMsgReturn)' -- please make this neater with string.format()
  --print(send_string)
  udp:Send(ip_address, udp_port, send_string)
end

function fn_read_json_command(cmd, val)
  local send_string = 'GetPatchJSONWithDescriptor("/' .. cmd .. '", ' .. val .. ")"
  --local send_string = 'WatchPatchJSONWithDescriptor("/' .. cmd .. '", ' .. val .. ")"

  --print(send_string)
  udp:Send(ip_address, udp_port, send_string)
end

function fn_send_json(cmd, val)
  local encoded_val = json.encode(val)
  local send_string = 'localSVPatch.UpdatePatchJSON("/' .. cmd .. '", ' .. encoded_val .. ")"
  --print(send_string)
  udp:Send(ip_address, udp_port, send_string)
end

udp.Data = function(udp, packet)
  still_alive()
  --print("BUZZ!", packet.Data, rapidjson.decode(packet.Data))
  if rapidjson.decode(packet.Data) ~= nil then
    local response = rapidjson.decode(packet.Data)
    local data = rapidjson.decode(response.data)
    --print(response.descriptor)
    if response.descriptor == "/System Settings" then
      Controls.ip_address.String = data.ipAddress
      Controls.device_name.String = data.deviceName
    elseif response.descriptor == "/Media List" then
      local file_choice_list = {}
      for _, file in ipairs(data.files) do
        file_list[file.name] = file.fileIndex - 1
        table.insert(file_choice_list, file.name)
        file_metadata_list[file.name] = file
        for i = 1, layer_count do
          if Controls[string.format("media_name_%s_layer_%s", file.fileIndex, i)] then
            Controls[string.format("media_name_%s_layer_%s", file.fileIndex, i)].String = file.name
          end
        end
        get_file_thumbnail(file.fileIndex, file.name)
      end
      for i = 1, layer_count do
        Controls["file_select_" .. i].Choices = file_choice_list
      end
    elseif response.descriptor == "/Output Mapping" then
    elseif response.descriptor == "/Play List" then
      for _, layer in ipairs(response.layers) do
        --print(layer.label)
      end
    elseif response.descriptor == "/Timecode Cue List" then
    elseif response.descriptor == "/Vioso WB Settings" then
    elseif response.descriptor == "/Screenberry WB Settings" then
    elseif response.descriptor:sub(1, 6) == "/LAYER" then -- Layer parameter response
      --[[if response.descriptor:match("/LAYER (%d+)/(%P+)") then
        print("yoo", response.descriptor, data)
      else]]
      local layer, parameter = response.descriptor:match("/LAYER (%d+)/(%P+)/Value")
      if parameter then
        local control = string.format("%s_%s", parameter:gsub("%s", "_"):lower(), layer)
        if parameter == "FILE SELECT" then
          for k, v in pairs(file_list) do
            if v == data then
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
        elseif parameter:sub(-5, -1) == "FRAME" then
          Controls[control].Value = data
        elseif parameter == "PLAY MODE" then
          for k, v in pairs(play_mode_list) do
            if v == data then
              Controls[control].String = k
              break
            end
          end
        elseif parameter == "FRAMING MODE" then
          for k, v in pairs(framing_mode_list) do
            if v == data then
              Controls[control].String = k
              break
            end
          end
        elseif parameter == "BLEND MODE" then
          for k, v in pairs(blend_mode_list) do
            if v == data then
              Controls[control].String = k
              break
            end
          end
        elseif parameter == "PLAY SPEED" or parameter == "SCALE" then
          if data >= 0.5 then
            Controls[control].Position = (data - 0.4444444444444444) / 0.5555555555555556
          else
            Controls[control].Position = data / 5
          end
        elseif parameter:sub(1, 3) == "MTC" then
          Controls[control].Value = data
        elseif parameter:sub(1, 8) == "POSITION" then
          Controls[control].Value = (data * 200) - 100
        elseif parameter:sub(1, 8) == "ROTATION" then
          Controls[control].Value = (data * 2880) - 1440
        elseif
          parameter == "RED" or parameter == "BLUE" or parameter == "GREEN" or parameter == "SATURATION" or
            parameter == "CONTRAST"
         then
          Controls[control].Value = (data * 200) - 100
        else -- parameters where data directly proportional to position
          Controls[control].Position = data
        end
      else
        local layer, parameter = response.descriptor:match("/LAYER (%d+)/(%P+)")
        if parameter == "Transport Control" then
          local layer, parameter, sub_parameter = response.descriptor:match("/LAYER (%d+)/(%P+)/(%P+)")
          print("Transport Control feedback received!", data)
          print(string.format("Layer: %s, parameter: %s, sub-parameter: %s", layer, parameter, sub_parameter))
          if sub_parameter == "Media Time" then
            print(
              "Check processing criteria:",
              Controls["file_select_" .. layer].String ~= "",
              not seek_timer_list[tonumber(layer)]:IsRunning()
            )
            if Controls["file_select_" .. layer].String ~= "" and not seek_timer_list[tonumber(layer)]:IsRunning() then
              local pos = tonumber(data) / file_metadata_list[Controls["file_select_" .. layer].String].duration
              print(
                string.format(
                  "Statement triggered, calcuated position is %s and formatted date is %s",
                  pos,
                  os.date("!%X", math.floor(data))
                )
              )
              Controls["seek_" .. layer].Position = pos
              Controls["time_elapsed_" .. layer].String = os.date("!%X", math.floor(data))
            else
              print(
                string.format(
                  "Feedback processing did not trigger. File was %s and seek timer running status was %s",
                  Controls["file_select_" .. layer].String,
                  seek_timer_list[tonumber(layer)]:IsRunning()
                )
              )
            end
          end
        end
      end
    end
  end
end

--[[
function get_live_preview()
  HttpClient.Download {
    Url = string.format("http://%s/Honey/status.txt", ip_address),
    Headers = {},
    Auth = "basic",
    Timeout = 10,
    EventHandler = function(table, code, data, err, headers)
      print(string.format("http://%s/Honey/outputFrame_%s.jpg", ip_address, data))
      HttpClient.Download {
        Url = string.format("http://%s/Honey/outputFrame_%s.jpg", ip_address, data),
        Headers = {},
        Auth = "basic",
        Timeout = 10,
        EventHandler = function(table, code, data, err, headers)
          print(base_uri, code, data, err, headers)
          local iconStyle = {
            DrawChrome = true,
            HorizontalAlignment = "Center",
            Legend = "",
            Padding = 0,
            Margin = 0,
            IconData = Qlib.base64_enc(data)
          }
          Controls.thumbnail.Style = rapidjson.encode(iconStyle)
        end
      }
    end
  }
end
]]
function get_file_thumbnail(index, filename)
  if index <= media_item_count then
    HttpClient.Download {
      Url = string.format("http://%s/Thumbs/%s", ip_address, filename:gsub("%.%w+", ".jpg")),
      Headers = {},
      Auth = "basic",
      Timeout = 10,
      EventHandler = function(table, code, data, err, headers)
        if code == 200 then
          local iconStyle = {
            DrawChrome = true,
            HorizontalAlignment = "Center",
            Legend = "",
            Padding = 0,
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

-- Layer Parameters

function cmd_file_select(layer, x) -- 0..65535: File Select
  if file_metadata_list[Controls["file_select_" .. layer].String] then
    Controls["duration_" .. layer].String =
      os.date("!%X", math.floor(file_metadata_list[Controls["file_select_" .. layer].String].duration))
    fn_send(layer, "FILE SELECT", x)
  end
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
  fn_send(layer, "PLAY MODE", play_mode_list[x])
end

function cmd_framing(layer, x)
  fn_send(layer, "FRAMING MODE", framing_mode_list[x])
end

function cmd_blend_mode(layer, x)
  fn_send(layer, "BLEND MODE", blend_mode_list[x])
end

function cmd_lut_select(layer, x)
  fn_send(layer, "LUT", x)
end

function cmd_play_speed(layer, x)
  fn_send(layer, "PLAY SPEED", x)
end

function cmd_movement_speed(layer, x) -- reserved for future use
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

for i = 1, 2 do -- NO IDEA IF THIS WORKS! PLEASE TEST!!
  _G["cmd_fx" .. i .. "_select"] = function(layer, x)
    fn_send(layer, "FX" .. i .. " SELECT", x)
  end
  _G["cmd_fx" .. i .. "_opacity"] = function(layer, x)
    fn_send(layer, "FX" .. i .. " OPACITY", x)
  end
  for p = 1, 16 do
    _G["cmd_fx" .. i .. "_parameter_" .. p] = function(layer, x)
      fn_send(layer, "FX" .. i .. " PARAM " .. p, x)
    end
  end
end

for layer, seek_timer in pairs(seek_timer_list) do
  seek_timer.EventHandler = function(timer)
    if Controls[string.format("seek_%s", layer)].String == seek_last_value[layer] then
      if Controls["file_select_" .. layer].String ~= "" then
        --[[
        local second =
          file_metadata_list[Controls["file_select_" .. layer].String].duration * Controls["seek_" .. layer].Position
          ]]
        local frame =
          math.floor(
          file_metadata_list[Controls["file_select_" .. layer].String].duration *
            file_metadata_list[Controls["file_select_" .. layer].String].rate *
            Controls["seek_" .. layer].Position
        )
        udp:Send(
          ip_address,
          udp_port,
          string.format(
            'localSVPatch.SetPatchDouble("/LAYER %s/Transport Control/MediaClockGenerator/Seek", %s)',
            layer,
            frame + 1
          )
        )
        Timer.CallAfter(
          function()
            udp:Send(
              ip_address,
              udp_port,
              string.format(
                'localSVPatch.SetPatchDouble("/LAYER %s/Transport Control/MediaClockGenerator/Seek", %s)',
                layer,
                frame
              )
            )
          end,
          0.1
        )
      end
      seek_timer_list[layer]:Stop()
    end
    seek_last_value[layer] = Controls[string.format("seek_%s", layer)].String
  end
end

-- Read Device Settings

function cmd_read_system_settings()
  fn_read_json_command("System Settings", "UDPMsgReturn")
end

function cmd_read_media_list()
  fn_read_json_command("Media List", "UDPMsgReturn")
end

function cmd_read_output_mapping()
  fn_read_json_command("Output Mapping", "UDPMsgReturn")
end

function cmd_read_play_list()
  fn_read_json_command("Play List", "UDPMsgReturn")
end

function cmd_read_timecode_cue_list()
  fn_read_json_command("Timecode Cue List", "UDPMsgReturn")
end

function cmd_vioso_wb_settings()
  fn_read_json_command("Vioso WB Settings", "UDPMsgReturn")
end

function cmd_read_screenberry_wb_settings()
  fn_read_json_command("Screenberry WB Settings", "UDPMsgReturn")
end

-- Device Settings

-- Define Control EventHandlers
Controls["test"].EventHandler = function()
  if (Controls["test"].Value == 1) then
    print("Test button pressed!")
  -- Example of sending a command
  end
end

for i = 1, layer_count do
  Controls["file_select_" .. i].EventHandler = function()
    cmd_file_select(i, file_list[Controls["file_select_" .. i].String])
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
    cmd_play_mode(i, Controls["play_mode_" .. i].String)
  end
  Controls["framing_mode_" .. i].EventHandler = function()
    cmd_framing(i, Controls["framing_mode_" .. i].String)
  end
  Controls["blend_mode_" .. i].EventHandler = function()
    cmd_blend_mode(i, Controls["blend_mode_" .. i].String)
  end
  --[[Controls["lut_select_" .. i].EventHandler = function() --todo!
    cmd_lut_select(i, Controls["lut_select_" .. i].String)
  end]]
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

  for p = 1, media_item_count do
    Controls[string.format("media_thumbnail_%s_layer_%s", p, i)].EventHandler = function()
      if Controls[string.format("media_name_%s_layer_%s", p, i)].String ~= nil then
        cmd_file_select(i, file_list[Controls[string.format("media_name_%s_layer_%s", p, i)].String])
      end
    end
  end
  --TODO -- FX CONTROLS

  -- Choices
  Controls["play_mode_" .. i].Choices = play_mode_choices
  Controls["framing_mode_" .. i].Choices = framing_mode_choices
  Controls["blend_mode_" .. i].Choices = blend_mode_choices
  --Controls["fx_m" .. i].Choices = fx_choices
end

-- Connect
udp:Open("", udp_port)
fnPoll()
fn_poll_transport()
