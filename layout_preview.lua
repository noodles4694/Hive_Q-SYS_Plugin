table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = preview_groupbox_size
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
    Color = Colors.control_label,
    Position = {8, 8},
    Size = preview_size
  }
)

layout["OutputPreview"] = {
  PrettyName = "System~Preview",
  Style="Button",
  UnlinkOffColor = true,
  OffColor = Colors.transparent,
  Color = Colors.Black,
  StrokeColor = Colors.control_text,
  ButtonVisualStyle = "Flat",
  Position = {
     8,(2 * btn_size[2])
  },
  Size = preview_size,
  CornerRadius = 0,
  Margin = 0,
  Padding = 0
}

for i = 1, layer_count do
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = string.format("Layer %s\nPreview", i),
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Regular",
      HTextAlign = "Centre",
      Color = Colors.control_label,
      Position = {((i - 1) * preview_size[1]) + (3 * btn_size[1]) + 8, 8},
      Size = preview_size
    }
  )

  layout[string.format("Layer%sPreview", i)] = {
    PrettyName = string.format("Layer %s~Preview", i),
    UnlinkOffColor = true,
    OffColor = Colors.transparent,
    Color = Colors.Black,
    StrokeColor = Colors.control_text,
    ButtonVisualStyle = "Flat",
    Position = {
      ((i - 1) * preview_size[1]) + (3 * btn_size[1]) + 8,
      (2 * btn_size[2])
    },
    Size = preview_size,
    CornerRadius = 0,
    Margin = 0,
    Padding = 0
  }
end
