local i = tonumber(CurrentPage:match("Layer (%d+)"))
local fxColumnSize = math.ceil(FX1ItemCount / 2)
local layerGroupboxSize = {
  headerSize[1],
 ( (columnSize + 1) * (btnSize[2] + btnGap[2])) + btnGap[2]
}
local fxGroupboxSize = {
  headerSize[1],
  (fxColumnSize + 2) * btnSize[2] + btnGap[2]
}

local layerVerticalOffset = hiveHeaderSize[2] + btnGap[2]

table.insert(
  graphics,
  {
    Type = "Header",
    HTextAlign = "Center",
    Text = "Media",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, layerVerticalOffset},
    Size = headerSize
  }
)

layerVerticalOffset = layerVerticalOffset + headerSize[2] + btnGap[2]

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, layerVerticalOffset},
    Size = {headerSize[1], 7 * btnSize[2]}
  }
)

table.insert(
  graphics,
  {
    Type = "Text",
    Text = string.format("Layer %s Preview", i),
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Centre",
    Color = Colors.ControlLabel,
    Position = {btnGap[1], layerVerticalOffset + btnGap[2]},
    Size = {previewSize[1], btnSize[2]}
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
    btnGap[1],
    layerVerticalOffset + btnGap[2] + btnSize[2]
  },
  Size = previewSize,
  CornerRadius = 0,
  Margin = 0,
  Padding = 0
}

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Folder Select:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      (btnGap[1] * 2) + previewSize[1],
      btnGap[2] + layerVerticalOffset + btnSize[2]
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)

layout["FolderSelect " .. i] = {
  PrettyName = "Layer " .. i .. "~Folder Select",
  Style = "ComboBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (btnGap[1] * 3) + previewSize[1] + (3 * btnSize[1]),
    btnGap[2] + layerVerticalOffset + btnSize[2]
  },
  Size = {6 * btnSize[1], btnSize[2]}
}

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "File Select:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      (btnGap[1] * 2) + previewSize[1],
      (btnGap[2] * 2) + layerVerticalOffset + (2 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)

layout["FileSelect " .. i] = {
  PrettyName = "Layer " .. i .. "~File Select",
  Style = "ComboBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 8,
  StrokeWidth = 1,
  Position = {
    (btnGap[1] * 3) + previewSize[1] + (3 * btnSize[1]),
    (btnGap[2] * 2) + layerVerticalOffset + (2 * btnSize[2])
  },
  Size = {6 * btnSize[1], btnSize[2]}
}

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Time Elapsed:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      0,
      btnGap[2] + layerVerticalOffset + (4 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)

layout["TimeElapsed " .. i] = {
  PrettyName = "Layer " .. i .. "~Time Elapsed",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btnSize[1]),
    btnGap[2] + layerVerticalOffset + (4 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Duration:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      5 * btnSize[1],
      btnGap[2] + layerVerticalOffset + (4 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)

layout["Duration " .. i] = {
  PrettyName = "Layer " .. i .. "~Duration",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (8 * btnSize[1]),
    btnGap[2] + layerVerticalOffset + (4 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Seek:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      0,
      (btnGap[2] * 3) + layerVerticalOffset + (5 * btnSize[2])
    },
    Size = {2 * btnSize[1], btnSize[2]}
  }
)

layout["Seek " .. i] = {
  PrettyName = "Layer " .. i .. "~Seek",
  Style = "Fader",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    btnSize[1] * 2,
    (btnGap[2] * 3) + layerVerticalOffset + (5 * btnSize[2])
  },
  Size = {headerSize[1] - (2 * btnSize[1]) - btnGap[1], btnSize[2]}
}

layerVerticalOffset =
  layerVerticalOffset + (7 * btnSize[2]) + (1 * btnGap[2])

  table.insert(
  graphics,
  {
    Type = "Header",
    HTextAlign = "Center",
    Text = "Parameters",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, layerVerticalOffset},
    Size = headerSize
  }
)

layerVerticalOffset =
  layerVerticalOffset + btnSize[2] + (1 * btnGap[2])

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {
      0,
      layerVerticalOffset
    },
    Size = layerGroupboxSize
  }
)

layerVerticalOffset =
  layerVerticalOffset + layerGroupboxSize[2] + (1 * btnGap[2])

    table.insert(
  graphics,
  {
    Type = "Header",
    HTextAlign = "Center",
    Text = "Effects 1",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, layerVerticalOffset},
    Size = headerSize
  }
)

layerVerticalOffset =
  layerVerticalOffset + headerSize[2] + (1 * btnGap[2])

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {
      0,
      layerVerticalOffset
    },
    Size = fxGroupboxSize
  }
)

layerVerticalOffset =
  layerVerticalOffset + fxGroupboxSize[2] + (1 * btnGap[2])

    table.insert(
  graphics,
  {
    Type = "Header",
    HTextAlign = "Center",
    Text = "Effects 2",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, layerVerticalOffset},
    Size = headerSize
  }
)

layerVerticalOffset =
  layerVerticalOffset + headerSize[2] + (1 * btnGap[2])

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {
      0,
      layerVerticalOffset 
    },
    Size = fxGroupboxSize
  }
)

layerVerticalOffset = (7 * btnSize[2]) + hiveHeaderSize[2]  + (4 * btnGap[2]) + (headerSize[2] * 2)

local layCount = 0
for k, v in ipairs(control_list) do
  if v.Group == "Layer" then
    if v.Display == true then
      layCount = layCount + 1
      local column = math.floor((layCount - 1) / columnSize) + 1
      local row = layCount - (column - 1) * columnSize
      table.insert(
        graphics,
        {
          Type = "Text",
          Text = v.Label .. ":",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Regular",
          HTextAlign = "Right",
          Color = Colors.ControlLabel,
          Position = {
            ((6 * btnSize[1]) * (column - 1)),
            layerVerticalOffset + (row * btnSize[2]) + ((row - 1) * btnGap[2])
          },
          Size = {3 * btnSize[1], btnSize[2]}
        }
      )

      local controlCol = Colors.ControlBackground
      if v.Style == "Text Field" and v.ControlUnit == "Percent" then
        controlCol = Colors.ControlBackgroundLight
      end
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = controlCol,
        TextColor = Colors.ControlText,
        StrokeColor = Colors.ControlText,
        FontSize =  12,
        StrokeWidth = 1,
        Position = {
          ((6 * btnSize[1]) * (column - 1)) + (3 * btnSize[1]),
          layerVerticalOffset + (row * btnSize[2]) + ((row - 1) * btnGap[2])
        },
        Size = {3 * btnSize[1], btnSize[2]}
      }
    else
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = "None",
        Position = {
          0,
          0
        },
        Size = {5, 5}
      }
    end
  end
end

layerVerticalOffset = layerVerticalOffset + layerGroupboxSize[2] + headerSize[2]

local fxCount = 0
for k, v in ipairs(control_list) do
  if v.Group == "FX1" then
    if v.Display == true then
      fxCount = fxCount + 1
      local column = math.floor((fxCount - 1) / fxColumnSize) + 1
      local row = fxCount - (column - 1) * fxColumnSize
      table.insert(
        graphics,
        {
          Type = "Text",
          Text = v.Label .. ":",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Regular",
          HTextAlign = "Right",
          Color = Colors.ControlLabel,
          Position = {
            ((6 * btnSize[1]) * (column - 1)),
            layerVerticalOffset + (row * btnSize[2]) + ((row - 1) * btnGap[2])
          },
          Size = {3 * btnSize[1], btnSize[2]}
        }
      )

      local controlCol = Colors.ControlBackground
      if v.Style == "Text Field" and v.ControlUnit == "Percent" then
        controlCol = Colors.ControlBackgroundLight
      end
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = controlCol,
        TextColor = Colors.ControlText,
        StrokeColor = Colors.ControlText,
        FontSize =  12,
        StrokeWidth = 1,
        Position = {
          ((6 * btnSize[1]) * (column - 1)) + (3 * btnSize[1]),
          layerVerticalOffset + (row * btnSize[2]) + ((row - 1) * btnGap[2])
        },
        Size = {3 * btnSize[1], btnSize[2]}
      }
    else
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = "None",
        Position = {
          0,
          0
        },
        Size = {5, 5}
      }
    end
  end
end

layerVerticalOffset = layerVerticalOffset + fxGroupboxSize[2] + headerSize[2] + (2 * btnGap[2])

fxCount = 0
for k, v in ipairs(control_list) do
  if v.Group == "FX2" then
    if v.Display == true then
      fxCount = fxCount + 1
      local column = math.floor((fxCount - 1) / fxColumnSize) + 1
      local row = fxCount - (column - 1) * fxColumnSize
      table.insert(
        graphics,
        {
          Type = "Text",
          Text = v.Label .. ":",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Regular",
          HTextAlign = "Right",
          Color = Colors.ControlLabel,
          Position = {
            ((6 * btnSize[1]) * (column - 1)),
            layerVerticalOffset + (row * btnSize[2]) + ((row - 1) * btnGap[2])
          },
          Size = {3 * btnSize[1], btnSize[2]}
        }
      )

      local controlCol = Colors.ControlBackground
      if v.Style == "Text Field" and v.ControlUnit == "Percent" then
        controlCol = Colors.ControlBackgroundLight
      end
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = controlCol,
        TextColor = Colors.ControlText,
        StrokeColor = Colors.ControlText,
        FontSize =  12,
        StrokeWidth = 1,
        Position = {
          ((6 * btnSize[1]) * (column - 1)) + (3 * btnSize[1]),
          layerVerticalOffset + (row * btnSize[2]) + ((row - 1) * btnGap[2])
        },
        Size = {3 * btnSize[1], btnSize[2]}
      }
    else
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = "None",
        Position = {
          0,
          0
        },
        Size = {5, 5}
      }
    end
  end
end

