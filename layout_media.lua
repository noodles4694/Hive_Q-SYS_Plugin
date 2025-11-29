table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Media List",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = mediaListGroupboxSize
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
    Color = Colors.ControlLabel,
    Position = {0, (1 * btnSize[2])},
    Size = {2 * btnSize[1], btnSize[2]}
  }
)

for i = 1, layerCount do
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = string.format("Layer %s\nClip Select", i),
      Font = "Roboto",
      FontSize = 12,
      FontStyle = "Regular",
      HTextAlign = "Centre",
      Color = Colors.ControlLabel,
      Position = {((i - 1) * previewSize[1]) + (3 * btnSize[1]) + 8, 8},
      Size = previewSize
    }
  )
  for p = 1, mediaItemCount do
    layout[string.format("MediaName%s %s", p, i)] = {
      PrettyName = string.format("Layer %s~Media List~%s~Name", i, p),
      Style = "TextBox",
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      HTextAlign = "Right",
      VTextAlign = "Centre",
      FontSize = 8,
      WordWrap = true,
      StrokeWidth = 0,
      Position = {
        4,
        (2 * btnSize[2]) + ((p - 1) * previewSize[2])
      },
      Size = {3 * btnSize[1], previewSize[2]}
    }

    layout[string.format("MediaThumbnail%s %s", p, i)] = {
      PrettyName = string.format("Layer %s~Media List~%s~Select", i, p),
      UnlinkOffColor = true,
      OffColor = Colors.Transparent,
      Color = Colors.Red,
      StrokeColor = Colors.ControlText,
      ButtonVisualStyle = "Flat",
      Position = {
        ((i - 1) * previewSize[1]) + (3 * btnSize[1]) + 8,
        (2 * btnSize[2]) + ((p - 1) * previewSize[2])
      },
      Size = previewSize
    }
  end
end
