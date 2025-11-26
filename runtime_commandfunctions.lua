-- Command functions called by control callbacks
function CmdFileSelect(layer, x) -- 0..65535: File Select
  local currentFileName = file_list_names[selected_file[layer] + 1] or "None"
  if file_metadata_list[currentFileName] then
    Controls.Duration[layer].String = os.date("!%X", math.floor(file_metadata_list[currentFileName].duration))
  else
    Controls.Duration[layer].String = os.date("!%X", 0)
  end
  FnSend(layer, "FILE SELECT", x)
end

function CmdFolderSelect(layer, x) -- 0..65535: Folder Select
  FnSend(layer, "FOLDER SELECT", x)
end

function CmdIntensity(layer, x)
  FnSend(layer, "INTENSITY", x)
end

function CmdInFrame(layer, x)
  FnSend(layer, "IN FRAME", x)
end

function CmdOutFrame(layer, x)
  FnSend(layer, "OUT FRAME", x)
end

function CmdPlayMode(layer, x)
  FnSend(layer, "PLAY MODE", x)
end

function CmdFraming(layer, x)
  FnSend(layer, "FRAMING MODE", x)
end

function CmdBlendMode(layer, x)
  FnSend(layer, "BLEND MODE", x)
end

function CmdLutSelect(layer, x)
  FnSend(layer, "LUT", x)
end

function CmdPlaySpeed(layer, x)
  FnSend(layer, "PLAY SPEED", x)
end

function CmdMovementSpeed(layer, x)
  FnSend(layer, "MOVEMENT SPEED", x)
end

function CmdTcHour(layer, x)
  FnSend(layer, "MTC HOUR", x)
end

function CmdTcMinute(layer, x)
  FnSend(layer, "MTC MINUTE", x)
end

function CmdTcSecond(layer, x)
  FnSend(layer, "MTC SECOND", x)
end

function CmdTcFrame(layer, x)
  FnSend(layer, "MTC FRAME", x)
end

function CmdScale(layer, x)
  FnSend(layer, "SCALE", x)
end

function CmdAspectRatio(layer, x)
  FnSend(layer, "ASPECT RATIO", x)
end

function CmdPositionX(layer, x)
  FnSend(layer, "POSITION X", x)
end

function CmdPositionY(layer, x)
  FnSend(layer, "POSITION Y", x)
end

function CmdRotationX(layer, x)
  FnSend(layer, "ROTATION X", x)
end

function CmdRotationY(layer, x)
  FnSend(layer, "ROTATION Y", x)
end

function CmdRotationZ(layer, x)
  FnSend(layer, "ROTATION Z", x)
end

function CmdRed(layer, x)
  FnSend(layer, "RED", x)
end

function CmdGreen(layer, x)
  FnSend(layer, "GREEN", x)
end

function CmdBlue(layer, x)
  FnSend(layer, "BLUE", x)
end

function CmdHue(layer, x)
  FnSend(layer, "HUE", x)
end

function CmdSaturation(layer, x)
  FnSend(layer, "SATURATION", x)
end

function CmdContrast(layer, x)
  FnSend(layer, "CONTRAST", x)
end

function CmdStrobe(layer, x)
  FnSend(layer, "STROBE", x)
end

function CmdVolume(layer, x)
  FnSend(layer, "VOLUME", x)
end

function CmdTransitionDuration(layer, x)
  FnSend(layer, "TRANSITION DURATION", x)
end

function CmdTransitionMode(layer, x)
  FnSend(layer, "TRANSITION MODE", x)
end

function CmdEnablePlaylist(x)
  FnUpdateJson("Play List", {{op = "replace", path = "/usePlayList", value = x}})
end

function CmdEnableTimeline(x)
  FnUpdateJson("Timeline", {{op = "replace", path = "/useTimeline", value = x}})
end

function CmdEnableSchedule(x)
  FnUpdateJson("Schedule", {{op = "replace", path = "/useSchedule", value = x}})
end

function CmdEnableTc1(x)
  FnUpdateJson("Timecode Cue List", {{op = "replace", path = "/layers/0/useCueList", value = x}})
end

function CmdEnableTc2(x)
  FnUpdateJson("Timecode Cue List", {{op = "replace", path = "/layers/1/useCueList", value = x}})
end

function CmdUpdateSettingsData(x)
      FnLogDebug("Updating System Settings JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz settings list") == false then
    FnLogError("Not sending invalid System Settings JSON data")
    return
  end
  FnSendJson("System Settings", rapidjson.decode(x))
end

function CmdUpdateTimelineData(x)
    FnLogDebug("Updating Timeline JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz timeline") == false then
    FnLogError("Not sending invalid Timeline JSON data")
    return
  end
  FnSendJson("Timeline", rapidjson.decode(x))
end

function CmdUpdateSchedulerData(x)
  FnLogDebug("Updating Scheduler JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz schedule") == false then
    FnLogError("Not sending invalid Scheduler JSON data")
    return
  end
  FnSendJson("Schedule", rapidjson.decode(x))
end

function CmdUpdateTimecodeData(x)
  FnLogDebug("Updating Timecode Cue List JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz cue list") == false then
    FnLogError("Not sending invalid Timecode Cue List JSON data")
    return
  end
  FnSendJson("Timecode Cue List", rapidjson.decode(x))
end

function CmdUpdatePlaylistData(x)
  FnLogDebug("Updating Output Playlist JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz play list") == false then
    FnLogError("Not sending invalid Playlist JSON data")
    return
  end
  FnSendJson("Play List", rapidjson.decode(x))
end

function CmdUpdateMappingData(x)
  FnLogDebug("Updating Output Mapping JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz mapping region list") == false then
    FnLogError("Not sending invalid Output Mapping JSON data")
    return
  end
  FnSendJson("Output Mapping", rapidjson.decode(x))
end

function CheckHiveJsonDataValidity(json_string, description)
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

function CmdPlaylistPlayPrevious()
  if playlist_row_count > 0 then
    local new_row = playlist_active_row - 1
    if new_row < 1 then
      new_row = playlist_row_count
    end
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function CmdPlaylistPlayNext()
  if playlist_row_count > 0 then
    local new_row = playlist_active_row + 1
    if new_row > playlist_row_count then
      new_row = 1
    end
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function CmdPlaylistPlayFirst()
  if playlist_row_count > 0 then
    local new_row = 1
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function CmdPlaylistPlayLast()
  if playlist_row_count > 0 then
    local new_row = playlist_row_count
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function CmdPlaylistPlayRow(x)
  if playlist_row_count > 0 then
    local new_row = x
    if new_row < 1 then
      new_row = 1
    end
    if new_row > playlist_row_count then
      new_row = playlist_row_count
    end
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", new_row - 1)
  end
end

function CmdRestart()
  if wsConnected ~= true then
    return
  end
  FnLogMessage("Sending restart command to device")
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
        FnLogMessage("Restart command sent")
      else
        FnLogError("Failed to send restart command: HTTP " .. tostring(code))
      end
    end
  }
end

function CmdShutdown()
  if wsConnected ~= true then
    return
  end
  FnLogMessage("Sending shutdown command to device")
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
        FnLogMessage("Shutdown command sent")
      else
        FnLogError("Failed to send shutdown command: HTTP " .. tostring(code))
      end
    end
  }
end

function CmdWake()
  FnLogMessage("Sending wake command to device")
  local ok, err = WakeOnLan(Properties["MAC Address"].Value)
  if not ok then
    FnLogError("Failed to send wake command: " .. tostring(err))
  else
    FnLogMessage("Wake command sent")
  end
end

for i = 1, 2 do
  _G["CmdFx" .. i .. "Select"] = function(layer, x)
    FnSend(layer, "FX" .. i .. " SELECT", x)
  end
  _G["CmdFx" .. i .. "Opacity"] = function(layer, x)
    FnSend(layer, "FX" .. i .. " OPACITY", x)
  end
  for p = 1, 16 do
    _G["CmdFx" .. i .. "Param" .. p] = function(layer, x)
      FnSend(layer, "FX" .. i .. " PARAM " .. p, x)
    end
  end
end
