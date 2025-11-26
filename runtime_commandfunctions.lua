-- Command functions called by control callbacks
function CmdFileSelect(layer, x) -- 0..65535: File Select
  local currentFileName = fileListNames[selectedFile[layer] + 1] or "None"
  if fileMetadataList[currentFileName] then
    Controls.Duration[layer].String = os.date("!%X", math.floor(fileMetadataList[currentFileName].duration))
  else
    Controls.Duration[layer].String = os.date("!%X", 0)
  end
  Send(layer, "FILE SELECT", x)
end

function CmdFolderSelect(layer, x) -- 0..65535: Folder Select
  Send(layer, "FOLDER SELECT", x)
end

function CmdIntensity(layer, x)
  Send(layer, "INTENSITY", x)
end

function CmdInFrame(layer, x)
  Send(layer, "IN FRAME", x)
end

function CmdOutFrame(layer, x)
  Send(layer, "OUT FRAME", x)
end

function CmdPlayMode(layer, x)
  Send(layer, "PLAY MODE", x)
end

function CmdFraming(layer, x)
  Send(layer, "FRAMING MODE", x)
end

function CmdBlendMode(layer, x)
  Send(layer, "BLEND MODE", x)
end

function CmdLutSelect(layer, x)
  Send(layer, "LUT", x)
end

function CmdPlaySpeed(layer, x)
  Send(layer, "PLAY SPEED", x)
end

function CmdMovementSpeed(layer, x)
  Send(layer, "MOVEMENT SPEED", x)
end

function CmdTcHour(layer, x)
  Send(layer, "MTC HOUR", x)
end

function CmdTcMinute(layer, x)
  Send(layer, "MTC MINUTE", x)
end

function CmdTcSecond(layer, x)
  Send(layer, "MTC SECOND", x)
end

function CmdTcFrame(layer, x)
  Send(layer, "MTC FRAME", x)
end

function CmdScale(layer, x)
  Send(layer, "SCALE", x)
end

function CmdAspectRatio(layer, x)
  Send(layer, "ASPECT RATIO", x)
end

function CmdPositionX(layer, x)
  Send(layer, "POSITION X", x)
end

function CmdPositionY(layer, x)
  Send(layer, "POSITION Y", x)
end

function CmdRotationX(layer, x)
  Send(layer, "ROTATION X", x)
end

function CmdRotationY(layer, x)
  Send(layer, "ROTATION Y", x)
end

function CmdRotationZ(layer, x)
  Send(layer, "ROTATION Z", x)
end

function CmdRed(layer, x)
  Send(layer, "RED", x)
end

function CmdGreen(layer, x)
  Send(layer, "GREEN", x)
end

function CmdBlue(layer, x)
  Send(layer, "BLUE", x)
end

function CmdHue(layer, x)
  Send(layer, "HUE", x)
end

function CmdSaturation(layer, x)
  Send(layer, "SATURATION", x)
end

function CmdContrast(layer, x)
  Send(layer, "CONTRAST", x)
end

function CmdStrobe(layer, x)
  Send(layer, "STROBE", x)
end

function CmdVolume(layer, x)
  Send(layer, "VOLUME", x)
end

function CmdTransitionDuration(layer, x)
  Send(layer, "TRANSITION DURATION", x)
end

function CmdTransitionMode(layer, x)
  Send(layer, "TRANSITION MODE", x)
end

function CmdEnablePlaylist(x)
  UpdateJson("Play List", {{op = "replace", path = "/usePlayList", value = x}})
end

function CmdEnableTimeline(x)
  UpdateJson("Timeline", {{op = "replace", path = "/useTimeline", value = x}})
end

function CmdEnableSchedule(x)
  UpdateJson("Schedule", {{op = "replace", path = "/useSchedule", value = x}})
end

function CmdEnableTc1(x)
  UpdateJson("Timecode Cue List", {{op = "replace", path = "/layers/0/useCueList", value = x}})
end

function CmdEnableTc2(x)
  UpdateJson("Timecode Cue List", {{op = "replace", path = "/layers/1/useCueList", value = x}})
end

function CmdUpdateSettingsData(x)
  LogDebug("Updating System Settings JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz settings list") == false then
    LogError("Not sending invalid System Settings JSON data")
    return
  end
  SendJson("System Settings", rapidjson.decode(x))
end

function CmdUpdateTimelineData(x)
  LogDebug("Updating Timeline JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz timeline") == false then
    LogError("Not sending invalid Timeline JSON data")
    return
  end
  SendJson("Timeline", rapidjson.decode(x))
end

function CmdUpdateSchedulerData(x)
  LogDebug("Updating Scheduler JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz schedule") == false then
    LogError("Not sending invalid Scheduler JSON data")
    return
  end
  SendJson("Schedule", rapidjson.decode(x))
end

function CmdUpdateTimecodeData(x)
  LogDebug("Updating Timecode Cue List JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz cue list") == false then
    LogError("Not sending invalid Timecode Cue List JSON data")
    return
  end
  SendJson("Timecode Cue List", rapidjson.decode(x))
end

function CmdUpdatePlaylistData(x)
  LogDebug("Updating Output Playlist JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz play list") == false then
    LogError("Not sending invalid Playlist JSON data")
    return
  end
  SendJson("Play List", rapidjson.decode(x))
end

function CmdUpdateMappingData(x)
  LogDebug("Updating Output Mapping JSON data")
  if CheckHiveJsonDataValidity(x, "hive buzz mapping region list") == false then
    LogError("Not sending invalid Output Mapping JSON data")
    return
  end
  SendJson("Output Mapping", rapidjson.decode(x))
end

function CheckHiveJsonDataValidity(jsonString, description)
  -- check it can be encoded as JSON and matches expected description
  local status, result = pcall(rapidjson.decode, jsonString)
  if status then
    if result and result.description == description then
      return true
    else
      LogError("Invalid " .. description .. " JSON data")
      return false
    end
  else
    LogError("Invalid " .. description .. " JSON data")
    return false
  end
end

function CmdPlaylistPlayPrevious()
  if playlistRowCount > 0 then
    local newRow = playlistActiveRow - 1
    if newRow < 1 then
      newRow = playlistRowCount
    end
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", newRow - 1)
  end
end

function CmdPlaylistPlayNext()
  if playlistRowCount > 0 then
    local newRow = playlistActiveRow + 1
    if newRow > playlistRowCount then
      newRow = 1
    end
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", newRow - 1)
  end
end

function CmdPlaylistPlayFirst()
  if playlistRowCount > 0 then
    local newRow = 1
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", newRow - 1)
  end
end

function CmdPlaylistPlayLast()
  if playlistRowCount > 0 then
    local newRow = playlistRowCount
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", newRow - 1)
  end
end

function CmdPlaylistPlayRow(x)
  if playlistRowCount > 0 then
    local newRow = x
    if newRow < 1 then
      newRow = 1
    end
    if newRow > playlistRowCount then
      newRow = playlistRowCount
    end
    SetPatchDouble("/Playlist Control/Playlist Controller 1/Play List Next", newRow - 1)
  end
end

function CmdRestart()
  if wsConnected ~= true then
    return
  end
  LogMessage("Sending restart command to device")
  local url = string.format("http://%s/api/runSystemCommand", ipAddress)
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
        LogMessage("Restart command sent")
      else
        LogError("Failed to send restart command: HTTP " .. tostring(code))
      end
    end
  }
end

function CmdShutdown()
  if wsConnected ~= true then
    return
  end
  LogMessage("Sending shutdown command to device")
  local url = string.format("http://%s/api/runSystemCommand", ipAddress)
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
        LogMessage("Shutdown command sent")
      else
        LogError("Failed to send shutdown command: HTTP " .. tostring(code))
      end
    end
  }
end

function CmdWake()
  LogMessage("Sending wake command to device")
  local ok, err = WakeOnLan(Properties["MAC Address"].Value)
  if not ok then
    LogError("Failed to send wake command: " .. tostring(err))
  else
    LogMessage("Wake command sent")
  end
end

for i = 1, 2 do
  _G["CmdFx" .. i .. "Select"] = function(layer, x)
    Send(layer, "FX" .. i .. " SELECT", x)
  end
  _G["CmdFx" .. i .. "Opacity"] = function(layer, x)
    Send(layer, "FX" .. i .. " OPACITY", x)
  end
  for p = 1, 16 do
    _G["CmdFx" .. i .. "Param" .. p] = function(layer, x)
      Send(layer, "FX" .. i .. " PARAM " .. p, x)
    end
  end
end
