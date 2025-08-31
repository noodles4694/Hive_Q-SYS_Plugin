CreatePages()
table.insert(
  ctrls,
  {
    Name = "online",
    ControlType = "Indicator",
    IndicatorType = "Led",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)
table.insert(
  ctrls,
  {
    Name = "ip_address",
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
    Name = "device_name",
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
    Name = "version",
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
    Name = "status",
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
    Name = "output_resolution",
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
    Name = "output_framerate",
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
    Name = "engine_fps",
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
    Name = "activity",
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
    Name = "netmask",
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
    Name = "serial",
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
    Name = "bee_type",
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
    Name = "file_count",
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
    Name = "free_space",
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
    Name = "cpu_power",
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
    Name = "sync_status",
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
    Name = "thumbnail",
    ControlType = "Button",
    ButtonType = "Momentary",
    PinStyle = "Output",
    Count = 1,
    UserPin = true
  }
)

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
        Name = string.format("media_name_%s_layer_%s", p, i),
        ControlType = "Indicator",
        IndicatorType = "Text",
        PinStyle = "Output",
        UserPin = true
      }
    )
    table.insert(
      ctrls,
      {
        Name = string.format("media_thumbnail_%s_layer_%s", p, i),
        ControlType = "Button",
        ButtonType = "StateTrigger",
        Min = 0,
        Max = 1,
        PinStyle = "None",
        UserPin = false
      }
    )
    table.insert(
      ctrls,
      {
        Name = "playlist_enable",
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
        Name = "l1_timecode_enable",
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
        Name = "l2_timecode_enable",
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
        Name = "timeline_enable",
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
        Name = "schedule_enable",
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
        Name = "playlist_rows",
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
        Name = "playlist_current_row",
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
        Name = "l1_tc_rows",
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
        Name = "l2_tc_rows",
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
        Name = "playlist_play_previous",
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
        Name = "playlist_play_next",
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
        Name = "playlist_play_first",
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
        Name = "playlist_play_last",
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
        Name = "playlist_play_row",
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
        Name = "playlist_play_row_index",
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
        Name = "system_restart",
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
        Name = "system_shutdown",
        ControlType = "Button",
        ButtonType = "Trigger",
        PinStyle = "Input",
        Count = 1,
        UserPin = true
      }
    )
  end
end
