CreatePages()
-- Controls for Status Page
table.insert(
  ctrls,
  {
    Name = "IPAddress",
    ControlType = "Text",
    --IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "DeviceName",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Version",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Status",
    ControlType = "Indicator",
    IndicatorType = "Status",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "OutputResolution",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "OutputFramerate",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "EngineFPS",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Activity",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Netmask",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "SerialNumber",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "BeeType",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "FileCount",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Universe",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "FreeSpace",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "CpuPower",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "SyncStatus",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "Thumbnail",
    ControlType = "Button",
    ButtonType = "Momentary",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)

-- Controls for Media, Preview and Layers Pages
for i = 1, layer_count do
  for k, v in pairs(control_list) do
    table.insert(
      ctrls,
      {
        Name = v.Name .. i,
        ControlType = v.ControlType,
        ControlUnit = v.ControlUnit,
        Min = v.Min,
        Max = v.Max,
        PinStyle = v.PinStyle,
        UserPin = v.UserPin
      }
    )
  end
  for p = 1, max_media_items do
    table.insert(
      ctrls,
      {
        Name = string.format("MediaName%sLayer%s", p, i),
        ControlType = "Indicator",
        IndicatorType = "Text",
        PinStyle = "Output",
        UserPin = true
      }
    )
    table.insert(
      ctrls,
      {
        Name = string.format("MediaThumbnail%sLayer%s", p, i),
        ControlType = "Button",
        ButtonType = "StateTrigger",
        Min = 0,
        Max = 1,
        PinStyle = "None",
        UserPin = false
      }
    )
  end
  table.insert(
    ctrls,
    {
      Name = string.format("Layer%sPreview", i),
      ControlType = "Button",
      ButtonType = "Trigger",
      UserPin = false
    }
  )
end

table.insert(
  ctrls,
  {
    Name = "OutputPreview",
    ControlType = "Button",
    ButtonType = "Trigger",
    UserPin = false
  }
)
-- Controls for Modules Page
table.insert(
  ctrls,
  {
    Name = "PlaylistEnable",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "L1TimecodeEnable",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "L2TimecodeEnable",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "TimelineEnable",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "ScheduleEnable",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistRows",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    PinStyle = "Output",
    Min = 0,
    Max = 9999999,
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistCurrentRow",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    PinStyle = "Output",
    Min = 0,
    Max = 9999999,
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "L1TCRows",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    PinStyle = "Output",
    Min = 0,
    Max = 9999999,
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "L2TCRows",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    PinStyle = "Output",
    Min = 0,
    Max = 9999999,
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistPlayPrevious",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistPlayNext",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistPlayFirst",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistPlayLast",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistPlayRow",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistPlayRowIndex",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    PinStyle = "Both",
    Min = 1,
    Max = 9999999,
    DefaultValue = 1,
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "SystemRestart",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "SystemShutdown",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)

table.insert(
  ctrls,
  {
    Name = "SystemWake",
    ControlType = "Button",
    ButtonType = "Trigger",
    PinStyle = "Input",
    Count = 1,
    UserPin = true
  }
)

-- Controls for pin only - not to be displayed

table.insert(
  ctrls,
  {
    Name = "PreviewEnable",
    ControlType = "Button",
    ButtonType = "Toggle",
    PinStyle = "Both",
    Count = 1,
    DefaultValue = 1,
    UserPin = true
  }
)

table.insert(
  ctrls,
  {
    Name = "LogMessage",
    ControlType = "Text",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)


table.insert(
  ctrls,
  {
    Name = "SettingsJSON",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "MappingJSON",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "PlaylistJSON",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "TimecodeJSON",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "TimelineJSON",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "SchedulerJSON",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Both",
    Count = 1,
    UserPin = true
  }
)
