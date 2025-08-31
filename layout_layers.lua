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
for k, v in pairs(parameter_list) do
  local column = math.floor((k - 1) / column_size) + 1
  local row = k - (column - 1) * column_size
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = v .. ":",
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
  if control_list[v].Style == "Text Field" and control_list[v].ControlUnit == "Percent" then
    controlCol = Colors.control_background_light
  end
  layout[control_list[v].Name .. i] = {
    PrettyName = "Layer " .. i .. "~" .. v,
    Style = control_list[v].Style,
    Color = controlCol,
    TextColor = Colors.control_text,
    StrokeColor = Colors.control_text,
    FontSize = (v == "File Select") and 8 or 12,
    StrokeWidth = 1,
    Position = {
      player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)) + (3 * btn_size[1]),
      player_groupbox_position[2] + (row * btn_size[2])
    },
    Size = {3 * btn_size[1], btn_size[2]}
  }
end
for k, v in pairs(fx1_list) do
  local column = math.floor((k - 1) / fx1_column_size) + 1
  local row = k - (column - 1) * fx1_column_size
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = v .. ":",
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
  local controlCol = Colors.control_background
  if control_list[v].Style == "Text Field" and control_list[v].ControlUnit == "Percent" then
    controlCol = Colors.control_background_light
  end
  layout[control_list[v].Name .. i] = {
    PrettyName = "Layer " .. i .. "~" .. v,
    Style = control_list[v].Style,
    Color = controlCol,
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
end
for k, v in pairs(fx2_list) do
  local column = math.floor((k - 1) / fx2_column_size) + 1
  local row = k - (column - 1) * fx2_column_size
  table.insert(
    graphics,
    {
      Type = "Text",
      Text = v .. ":",
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
  local controlCol = Colors.control_background
  if control_list[v].Style == "Text Field" and control_list[v].ControlUnit == "Percent" then
    controlCol = Colors.control_background_light
  end
  layout[control_list[v].Name .. i] = {
    PrettyName = "Layer " .. i .. "~" .. v,
    Style = control_list[v].Style,
    Color = controlCol,
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
end