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
  end
end
