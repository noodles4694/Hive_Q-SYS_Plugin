CreatePages()
local CurrentPage = PageNames[props["page_index"].Value]
local media_item_count = props["Media List Count"].Value
local column_size = 11
local btn_size = {32, 24}
local status_groupbox_size = {9 * btn_size[1], 4 * btn_size[2]}
local player_groupbox_position = {0, 0}
local player_groupbox_size = {
  (((math.floor((#parameter_list / column_size)) + 1) * 6) + 1) * btn_size[1],
  (column_size + 2) * btn_size[2]
}
local preview_size = {3 * btn_size[1], (3 * btn_size[1])}
local media_list_groupbox_size = {3 * preview_size[1], (media_item_count + 1) * preview_size[2]}

if CurrentPage then
  if CurrentPage == "Info" then
    table.insert(
      graphics,
      {
        Type = "GroupBox",
        Text = "Setup",
        HTextAlign = "Left",
        CornerRadius = 8,
        Fill = Colors.hive_grey,
        StrokeWidth = 1,
        Position = {0, 0},
        Size = status_groupbox_size
      }
    )
    --[[table.insert(
      graphics,
      {
        Type = "Jpeg",
        Image = "images/logo.jpg", -- TODO
        Position = {21, 34},
        Size = {115, 36}
      }
    )]]
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "Online:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (0.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "IP Address:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (1.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "Device Name:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (2.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    layout["online"] = {
      PrettyName = "System~Online",
      Style = "Indicator",
      Color = {0, 255, 0},
      Position = {3 * btn_size[1], (0.5 * btn_size[2])},
      Size = {btn_size[2], btn_size[2]}
    }
    layout["ip_address"] = {
      PrettyName = "System~IP Address",
      Style = "TextBox",
      Position = {3 * btn_size[1], (1.5 * btn_size[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["device_name"] = {
      PrettyName = "System~Device Name",
      Style = "TextBox",
      Position = {3 * btn_size[1], (2.5 * btn_size[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
  elseif CurrentPage:sub(1, 6) == "Layer " then
    local i = tonumber(CurrentPage:match("Layer (%d+)"))

    table.insert(
      graphics,
      {
        Type = "GroupBox",
        Text = "Layer " .. i,
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
          FontStyle = "Bold",
          HTextAlign = "Right",
          Color = Colors.hive_yellow,
          Position = {
            player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)),
            player_groupbox_position[2] + (row * btn_size[2])
          },
          Size = {3 * btn_size[1], btn_size[2]}
        }
      )
      layout[control_list[v].Name .. i] = {
        PrettyName = "Layer " .. i .. "~" .. v,
        Style = control_list[v].Style,
        Position = {
          player_groupbox_position[1] + ((6 * btn_size[1]) * (column - 1)) + (3 * btn_size[1]),
          player_groupbox_position[2] + (row * btn_size[2])
        },
        Size = {3 * btn_size[1], btn_size[2]}
      }
    end
  elseif CurrentPage == "Media" then
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
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.hive_yellow,
        Position = {0, (1 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
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
          FontStyle = "Bold",
          HTextAlign = "Centre",
          Color = Colors.hive_yellow,
          Position = {i * 3 * btn_size[1], (1 * btn_size[2])},
          Size = {3 * btn_size[1], btn_size[2]}
        }
      )
      for p = 1, media_item_count do
        layout[string.format("media_name_%s_layer_%s", p, i)] = {
          PrettyName = string.format("Layer %s~Media List~%s~Name", i, p),
          Style = "TextBox",
          Position = {
            0 * btn_size[1],
            (2 * btn_size[2]) + ((p - 1) * preview_size[2]) + (preview_size[2] / 2) - (btn_size[2] / 2)
          },
          Size = {3 * btn_size[1], btn_size[2]}
        }
        layout[string.format("media_thumbnail_%s_layer_%s", p, i)] = {
          PrettyName = string.format("Layer %s~Media List~%s~Select", i, p),
          UnlinkOffColor = true,
          OffColor = Colors.transparent,
          Color = Colors.hive_yellow,
          StrokeColor = Colors.hive_yellow,
          Position = {i * 3 * btn_size[1], (2 * btn_size[2]) + ((p - 1) * preview_size[2])},
          Size = preview_size
        }
      end
    end
  --elseif string.find(CurrentPage, "Layer (%d+) Parameters") then
  --i = string.match(CurrentPage, "Layer (%d+) Parameters")
  end
end
