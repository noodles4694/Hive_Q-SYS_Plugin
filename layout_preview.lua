table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = previewGroupboxSize
  }
)

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Output Preview",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Centre",
    Color = Colors.ControlLabel,
    Position = {8, 8},
    Size = previewSize
  }
)

layout["OutputPreview"] = {
  PrettyName = "System~Preview",
  Style = "Button",
  UnlinkOffColor = true,
  OffColor = Colors.Transparent,
  Color = Colors.Black,
  StrokeColor = Colors.ControlText,
  ButtonVisualStyle = "Flat",
  Position = {
    8,
    (2 * btnSize[2])
  },
  Size = previewSize,
  CornerRadius = 0,
  Margin = 0,
  Padding = 0
}

for i = 1, layerCount do
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = string.format("Layer %s\nPreview", i),
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Regular",
      HTextAlign = "Centre",
      Color = Colors.ControlLabel,
      Position = {((i - 1) * previewSize[1]) + (3 * btnSize[1]) + 8, 8},
      Size = previewSize
    }
  )

  layout[string.format("LayerPreview %s", i)] = {
    PrettyName = string.format("Layer %s~Preview", i),
    UnlinkOffColor = true,
    OffColor = Colors.Transparent,
    Color = Colors.Black,
    StrokeColor = Colors.ControlText,
    ButtonVisualStyle = "Flat",
    Position = {
      ((i - 1) * previewSize[1]) + (3 * btnSize[1]) + 8,
      (2 * btnSize[2])
    },
    Size = previewSize,
    CornerRadius = 0,
    Margin = 0,
    Padding = 0
  }
end
