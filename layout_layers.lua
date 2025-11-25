local i = tonumber(CurrentPage:match("Layer (%d+)"))

table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Parameters",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {
      player_groupbox_position[1],
      player_groupbox_position[2]
    },
    Size = player_groupbox_size
  }
)
table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "FX 1",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {
      player_groupbox_position[1],
      player_groupbox_size[2] + 8
    },
    Size = fx1_groupbox_size
  }
)
table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "FX 2",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {
      player_groupbox_position[1],
      player_groupbox_size[2] + 16 + fx1_groupbox_size[2]
    },
    Size = fx2_groupbox_size
  }
)
local layerCount = 0
local fx1Count = 0
local fx2Count = 0
for k, v in ipairs(control_list) do
  if v.Group == "Layer" then
    if v.Display == true then
      layerCount = layerCount + 1
      local column = math.floor((layerCount - 1) / column_size) + 1
      local row = layerCount - (column - 1) * column_size
      table.insert(
        graphics,
        {
          Type = "Text",
          Text = v.Label .. ":",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Regular",
          HTextAlign = "Right",
          Color = Colors.control_label,
          Position = {
            player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)),
            player_groupbox_position[2] + (row * btn_size[2])
          },
          Size = {3 * btn_size[1], btn_size[2]}
        }
      )

      local controlCol = Colors.control_background
      if v.Style == "Text Field" and v.ControlUnit == "Percent" then
        controlCol = Colors.control_background_light
      end
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = controlCol,
        TextColor = Colors.control_text,
        StrokeColor = Colors.control_text,
        FontSize = (v.Label == "File Select") and 8 or 12,
        StrokeWidth = 1,
        Position = {
          player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)) + (3 * btn_size[1]),
          player_groupbox_position[2] + (row * btn_size[2])
        },
        Size = {3 * btn_size[1], btn_size[2]}
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
      local column = math.floor((fx1Count - 1) / fx1_column_size) + 1
      local row = fx1Count - (column - 1) * fx1_column_size
      table.insert(
        graphics,
        {
          Type = "Text",
          Text = v.Label .. ":",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Regular",
          HTextAlign = "Right",
          Color = Colors.control_label,
          Position = {
            player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)),
            player_groupbox_size[2] + 8 + (row * btn_size[2])
          },
          Size = {3 * btn_size[1], btn_size[2]}
        }
      )
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = Colors.control_background,
        TextColor = Colors.control_text,
        StrokeColor = Colors.control_text,
        FontSize = 12,
        StrokeWidth = 1,
        Position = {
          player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)) + (3 * btn_size[1]),
          player_groupbox_size[2] + 8 + (row * btn_size[2])
        },
        Size = {3 * btn_size[1], btn_size[2]}
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
      local column = math.floor((fx2Count - 1) / fx2_column_size) + 1
      local row = fx2Count - (column - 1) * fx2_column_size
      table.insert(
        graphics,
        {
          Type = "Text",
          Text = v.Label .. ":",
          Font = "Roboto",
          FontSize = 12,
          FontStyle = "Regular",
          HTextAlign = "Right",
          Color = Colors.control_label,
          Position = {
            player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)),
            player_groupbox_size[2] + 16 + fx1_groupbox_size[2] + (row * btn_size[2])
          },
          Size = {3 * btn_size[1], btn_size[2]}
        }
      )
      layout[v.Name .. " " .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v.Label,
        Style = v.Style,
        Color = Colors.control_background,
        TextColor = Colors.control_text,
        StrokeColor = Colors.control_text,
        FontSize = 12,
        StrokeWidth = 1,
        Position = {
          player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)) + (3 * btn_size[1]),
          player_groupbox_size[2] + 16 + fx1_groupbox_size[2] + (row * btn_size[2])
        },
        Size = {3 * btn_size[1], btn_size[2]}
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
