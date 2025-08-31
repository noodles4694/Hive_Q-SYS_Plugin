table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Media List",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = media_list_groupbox_size
  }
)
table.insert(
  graphics,
  {
    Type = "Text",
    Text = "File Name",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.control_label,
    Position = {0, (1 * btn_size[2])},
    Size = {2 * btn_size[1], btn_size[2]}
  }
)

for i = 1, layer_count do
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = string.format("Layer %s\nClip Select", i),
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Regular",
      HTextAlign = "Centre",
      Color = Colors.control_label,
      Position = {((i - 1) * preview_size[1]) + (3 * btn_size[1]) + 8, 8},
      Size = preview_size
    }
  )
  for p = 1, media_item_count do
    layout[string.format("media_name_%s_layer_%s", p, i)] = {
      PrettyName = string.format("Layer %s~Media List~%s~Name", i, p),
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      HTextAlign = "Right",
      VTextAlign = "Centre",
      FontSize = 8,
      WordWrap = true,
      StrokeWidth = 0,
      Position = {
        4,
        (2 * btn_size[2]) + ((p - 1) * preview_size[2])
      },
      Size = {3 * btn_size[1], preview_size[2]}
    }

    layout[string.format("media_thumbnail_%s_layer_%s", p, i)] = {
      PrettyName = string.format("Layer %s~Media List~%s~Select", i, p),
      UnlinkOffColor = true,
      OffColor = Colors.transparent,
      Color = Colors.Red,
      StrokeColor = Colors.control_text,
      ButtonVisualStyle = "Flat",
      Position = {
        ((i - 1) * preview_size[1]) + (3 * btn_size[1]) + 8,
        (2 * btn_size[2]) + ((p - 1) * preview_size[2])
      },
      Size = preview_size
    }
  end
end