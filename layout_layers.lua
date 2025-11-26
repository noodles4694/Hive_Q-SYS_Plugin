local i = tonumber(CurrentPage:match("Layer (%d+)"))

table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Parameters",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {
      playerGroupboxPosition[1],
      playerGroupboxPosition[2]
    },
    Size = playerGroupboxSize
  }
)
table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "FX 1",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {
      playerGroupboxPosition[1],
      playerGroupboxSize[2] + 8
    },
    Size = fx1GroupboxSize
  }
)
table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "FX 2",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {
      playerGroupboxPosition[1],
      playerGroupboxSize[2] + 16 + fx1GroupboxSize[2]
    },
    Size = fx2GroupboxSize
  }
)
local layerCount = 0
local fx1Count = 0
local fx2Count = 0
for k, v in ipairs(control_list) do
  if v.Group == "Layer" then
    if v.Display == true then
      layerCount = layerCount + 1
      local column = math.floor((layerCount - 1) / columnSize) + 1
      local row = layerCount - (column - 1) * columnSize
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
            playerGroupboxPosition[1] + ((6 * btnSize[1]) * (column - 1)),
            playerGroupboxPosition[2] + (row * btnSize[2])
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
        FontSize = (v.Label == "File Select") and 8 or 12,
        StrokeWidth = 1,
        Position = {
          playerGroupboxPosition[1] + ((6 * btnSize[1]) * (column - 1)) + (3 * btnSize[1]),
          playerGroupboxPosition[2] + (row * btnSize[2])
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
  elseif v.Group == "FX1" then
    if v.Display == true then
      fx1Count = fx1Count + 1
      local column = math.floor((fx1Count - 1) / fx1ColumnSize) + 1
      local row = fx1Count - (column - 1) * fx1ColumnSize
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
            playerGroupboxPosition[1] + ((6 * btnSize[1]) * (column - 1)),
            playerGroupboxSize[2] + 8 + (row * btnSize[2])
          },
          Size = {3 * btnSize[1], btnSize[2]}
        }
      )
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = Colors.ControlBackground,
        TextColor = Colors.ControlText,
        StrokeColor = Colors.ControlText,
        FontSize = 12,
        StrokeWidth = 1,
        Position = {
          playerGroupboxPosition[1] + ((6 * btnSize[1]) * (column - 1)) + (3 * btnSize[1]),
          playerGroupboxSize[2] + 8 + (row * btnSize[2])
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
  elseif v.Group == "FX2" then
    if v.Display == true then
      fx2Count = fx2Count + 1
      local column = math.floor((fx2Count - 1) / fx2ColumnSize) + 1
      local row = fx2Count - (column - 1) * fx2ColumnSize
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
            playerGroupboxPosition[1] + ((6 * btnSize[1]) * (column - 1)),
            playerGroupboxSize[2] + 16 + fx1GroupboxSize[2] + (row * btnSize[2])
          },
          Size = {3 * btnSize[1], btnSize[2]}
        }
      )
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = Colors.ControlBackground,
        TextColor = Colors.ControlText,
        StrokeColor = Colors.ControlText,
        FontSize = 12,
        StrokeWidth = 1,
        Position = {
          playerGroupboxPosition[1] + ((6 * btnSize[1]) * (column - 1)) + (3 * btnSize[1]),
          playerGroupboxSize[2] + 16 + fx1GroupboxSize[2] + (row * btnSize[2])
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
