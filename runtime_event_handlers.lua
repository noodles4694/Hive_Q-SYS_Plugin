-- Set up event handlers for controls
LogDebug("Setting up control event handlers")
for i = 1, layerCount do
  Controls.FileSelect[i].EventHandler = function()
    CmdFileSelect(i, fileList[Controls.FileSelect[i].String])
  end
  Controls.FolderSelect[i].EventHandler = function()
    CmdFolderSelect(i, folderList[Controls.FolderSelect[i].String])
  end
  Controls.FileSelectIndex[i].EventHandler = function()
    CmdFileSelect(i, Controls.FileSelectIndex[i].Value)
  end
  Controls.FolderSelectIndex[i].EventHandler = function()
    CmdFolderSelect(i, Controls.FolderSelectIndex[i].Value)
  end
  Controls.Intensity[i].EventHandler = function()
    CmdIntensity(i, Controls.Intensity[i].Position)
  end
  Controls.InFrame[i].EventHandler = function()
    CmdInFrame(i, Controls.InFrame[i].Value)
  end
  Controls.OutFrame[i].EventHandler = function()
    CmdOutFrame(i, Controls.OutFrame[i].Value)
  end
  Controls.PlayMode[i].EventHandler = function()
    local val = GetTableValue(playModeKeys, playModeValues, Controls.PlayMode[i].String)
    CmdPlayMode(i, val)
  end
  Controls.PlayModeIndex[i].EventHandler = function()
    CmdPlayMode(i, Controls.PlayModeIndex[i].Value)
  end
  Controls.FramingMode[i].EventHandler = function()
    local val = GetTableValue(framingModeKeys, framingModeValues, Controls.FramingMode[i].String)
    CmdFraming(i, val)
  end
  Controls.FramingModeIndex[i].EventHandler = function()
    CmdFraming(i, Controls.FramingModeIndex[i].Value)
  end
  Controls.BlendMode[i].EventHandler = function()
    local val = GetTableValue(blendModeKeys, blendModeValues, Controls.BlendMode[i].String)
    CmdBlendMode(i, val)
  end
  Controls.BlendModeIndex[i].EventHandler = function()
    CmdBlendMode(i, Controls.BlendModeIndex[i].Value)
  end
  Controls.FX1Select[i].EventHandler = function()
    local val = GetTableValue(fxKeys, fxValues, Controls.FX1Select[i].String)
    CmdFx1Select(i, val)
  end
  Controls.FX1SelectIndex[i].EventHandler = function()
    CmdFx1Select(i, Controls.FX1SelectIndex[i].Value)
  end
  Controls.FX2Select[i].EventHandler = function()
    local val = GetTableValue(fxKeys, fxValues, Controls.FX2Select[i].String)
    CmdFx2Select(i, val)
  end
  Controls.FX2SelectIndex[i].EventHandler = function()
    CmdFx2Select(i, Controls.FX2SelectIndex[i].Value)
  end
  Controls.Lut[i].EventHandler = function()
    CmdLutSelect(i, lutList[Controls.Lut[i].String])
  end
  Controls.LutIndex[i].EventHandler = function()
    CmdLutSelect(i, Controls.LutIndex[i].Value)
  end
  Controls.PlaySpeed[i].EventHandler = function()
    local converted_value = Controls.PlaySpeed[i].Position
    if Controls.PlaySpeed[i].Position >= 0.1 then
      converted_value = 0.5555555555555556 * Controls.PlaySpeed[i].Position + 0.4444444444444444
    else
      converted_value = 5 * Controls.PlaySpeed[i].Position
    end
    CmdPlaySpeed(i, converted_value)
  end
  Controls.MoveSpeed[i].EventHandler = function()
    CmdMovementSpeed(i, Controls.MoveSpeed[i].Position)
  end
  Controls.MtcHour[i].EventHandler = function()
    CmdTcHour(i, Controls.MtcHour[i].Value)
  end
  Controls.MtcMinute[i].EventHandler = function()
    CmdTcMinute(i, Controls.MtcMinute[i].Value)
  end
  Controls.MtcSecond[i].EventHandler = function()
    CmdTcSecond(i, Controls.MtcSecond[i].Value)
  end
  Controls.MtcFrame[i].EventHandler = function()
    CmdTcFrame(i, Controls.MtcFrame[i].Value)
  end
  Controls.Scale[i].EventHandler = function()
    local converted_value = Controls.Scale[i].Position
    if Controls.Scale[i].Position >= 0.1 then
      converted_value = 0.5555555555555556 * Controls.Scale[i].Position + 0.4444444444444444
    else
      converted_value = 5 * Controls.Scale[i].Position
    end
    CmdScale(i, converted_value)
  end
  Controls.AspectRatio[i].EventHandler = function()
    CmdAspectRatio(i, Controls.AspectRatio[i].Position)
  end
  Controls.PositionX[i].EventHandler = function()
    CmdPositionX(i, (Controls.PositionX[i].Value + 100) / 200)
  end
  Controls.PositionY[i].EventHandler = function()
    CmdPositionY(i, (Controls.PositionY[i].Value + 100) / 200)
  end
  Controls.RotationX[i].EventHandler = function()
    CmdRotationX(i, (Controls.RotationX[i].Value + 1440) / 2880)
  end
  Controls.RotationY[i].EventHandler = function()
    CmdRotationY(i, (Controls.RotationY[i].Value + 1440) / 2880)
  end
  Controls.RotationZ[i].EventHandler = function()
    CmdRotationZ(i, (Controls.RotationZ[i].Value + 1440) / 2880)
  end
  Controls.Red[i].EventHandler = function()
    CmdRed(i, (Controls.Red[i].Value + 100) / 200)
  end
  Controls.Green[i].EventHandler = function()
    CmdGreen(i, (Controls.Green[i].Value + 100) / 200)
  end
  Controls.Blue[i].EventHandler = function()
    CmdBlue(i, (Controls.Blue[i].Value + 100) / 200)
  end
  Controls.Hue[i].EventHandler = function()
    CmdHue(i, Controls.Hue[i].Position)
  end
  Controls.Saturation[i].EventHandler = function()
    CmdSaturation(i, (Controls.Saturation[i].Value + 100) / 200)
  end
  Controls.Contrast[i].EventHandler = function()
    CmdContrast(i, (Controls.Contrast[i].Value + 100) / 200)
  end
  Controls.Strobe[i].EventHandler = function()
    CmdStrobe(i, Controls.Strobe[i].Position)
  end
  Controls.Volume[i].EventHandler = function()
    CmdVolume(i, Controls.Volume[i].Position)
  end
  Controls.Seek[i].EventHandler = function()
    seekTimerList[i]:Start(.2)
  end
  Controls.TransitionDuration[i].EventHandler = function()
    CmdTransitionDuration(i, Controls.TransitionDuration[i].Value)
  end
  Controls.TransitionMode[i].EventHandler = function()
    local val = GetTableValue(transitionModeKeys, transitionModeValues, Controls.TransitionMode[i].String)
    CmdTransitionMode(i, val)
  end
  Controls.TransitionModeIndex[i].EventHandler = function()
    CmdTransitionMode(i, Controls.TransitionModeIndex[i].Value)
  end
  Controls.FX1Opacity[i].EventHandler = function()
    _G["CmdFx1Opacity"](i, Controls.FX1Opacity[i].Position)
  end
  Controls.FX2Opacity[i].EventHandler = function()
    _G["CmdFx2Opacity"](i, Controls.FX2Opacity[i].Position)
  end
  for p = 1, 16 do
    Controls[string.format("FX1Param%s", p)][i].EventHandler = function()
      _G["CmdFx1Param" .. p](i, Controls[string.format("FX1Param%s", p)][i].Position)
    end
    Controls[string.format("FX2Param%s", p)][i].EventHandler = function()
      _G["CmdFx2Param" .. p](i, Controls[string.format("FX2Param%s", p)][i].Position)
    end
  end

  for p = 1, mediaItemCount do
    Controls[string.format("MediaThumbnail%s", p)][i].EventHandler = function()
      if Controls[string.format("MediaName%s", p)][i].String ~= nil then
        CmdFileSelect(i, fileList[Controls[string.format("MediaName%s", p)][i].String])
      end
    end
  end
end

Controls.PlaylistEnable.EventHandler = function()
  CmdEnablePlaylist(Controls.PlaylistEnable.Boolean and 1 or 0)
end
Controls.TimelineEnable.EventHandler = function()
  CmdEnableTimeline(Controls.TimelineEnable.Boolean and 1 or 0)
end
Controls.ScheduleEnable.EventHandler = function()
  CmdEnableSchedule(Controls.ScheduleEnable.Boolean and 1 or 0)
end
Controls.L1TimecodeEnable.EventHandler = function()
  CmdEnableTc1(Controls.L1TimecodeEnable.Boolean and 1 or 0)
end
Controls.L2TimecodeEnable.EventHandler = function()
  CmdEnableTc2(Controls.L2TimecodeEnable.Boolean and 1 or 0)
end
Controls.PlaylistPlayPrevious.EventHandler = function()
  CmdPlaylistPlayPrevious()
end
Controls.PlaylistPlayNext.EventHandler = function()
  CmdPlaylistPlayNext()
end
Controls.PlaylistPlayFirst.EventHandler = function()
  CmdPlaylistPlayFirst()
end
Controls.PlaylistPlayLast.EventHandler = function()
  CmdPlaylistPlayLast()
end
Controls.PlaylistPlayRow.EventHandler = function()
  if Controls.PlaylistPlayRowIndex.String ~= "" then
    local row = tonumber(Controls.PlaylistPlayRowIndex.String)
    if row then
      CmdPlaylistPlayRow(row)
    end
  end
end
Controls.SystemShutdown.EventHandler = function()
  CmdShutdown()
end
Controls.SystemRestart.EventHandler = function()
  CmdRestart()
end
Controls.SystemWake.EventHandler = function()
  CmdWake()
end

Controls.SettingsJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    LogWarning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  CmdUpdateSettingsData(Controls.SettingsJSON.String)
end

Controls.TimelineJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    LogWarning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  CmdUpdateTimelineData(Controls.TimelineJSON.String)
end

Controls.SchedulerJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    LogWarning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  CmdUpdateSchedulerData(Controls.SchedulerJSON.String)
end

Controls.TimecodeJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    LogWarning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  CmdUpdateTimecodeData(Controls.TimecodeJSON.String)
end

Controls.PlaylistJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    LogWarning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  CmdUpdatePlaylistData(Controls.PlaylistJSON.String)
end
Controls.MappingJSON.EventHandler = function()
  if Properties["Enable JSON Data Pins (WARNING)"].Value ~= "Enabled" then
    LogWarning("Attempted to send Settings JSON data while JSON Data Pins are disabled in properties.")
    return
  end
  CmdUpdateMappingData(Controls.MappingJSON.String)
end

LogDebug("Control event handlers set up complete")
