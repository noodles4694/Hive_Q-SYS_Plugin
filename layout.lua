CreatePages()
local CurrentPage = PageNames[props["page_index"].Value]
local media_item_count = props["Media List Count"].Value
local column_size = 12
local fx1_column_size = 6
local fx2_column_size = 6
local btn_size = {32, 24}
local btn_gap = {4, 4}
local status_groupbox_size = {12.5 * btn_size[1], 11 * btn_size[2]}
local player_groupbox_position = {0, 0}
local player_groupbox_size = {
  (((math.floor((#parameter_list / column_size)) + 1) * 6) + 1) * btn_size[1],
  (column_size + 2) * btn_size[2]
}
local fx1_groupbox_size = {
  (((math.floor((#fx1_list / fx1_column_size))) * 6) + 1) * btn_size[1],
  (fx1_column_size + 2) * btn_size[2]
}
local fx2_groupbox_size = {
  (((math.floor((#fx2_list / fx2_column_size))) * 6) + 1) * btn_size[1],
  (fx2_column_size + 2) * btn_size[2]
}
local preview_size = {2.4 * btn_size[1], (1.35 * btn_size[1])}
local media_list_groupbox_size = {
  (2 * preview_size[1]) + 12 + (3 * btn_size[1]),
  ((media_item_count + 1) * preview_size[2]) + 8
}
local module_enable_groupbox_size = {(16 * btn_size[1]) + (4 * btn_gap[1]), (2* btn_size[2]) + (2 * btn_gap[2])}
local module_playlist_groupbox_size = {(16 * btn_size[1]) + (4 * btn_gap[1]), (6* btn_size[2]) + (2 * btn_gap[2])}

if CurrentPage then
  if CurrentPage == "Status" then
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
        Text = "ONLINE:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (0.5 * btn_size[2]) + (0 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "IP ADDRESS:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (1.5 * btn_size[2]) + (1 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "DEVICE NAME:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (2.5 * btn_size[2]) + (2 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "VERSION:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (3.5 * btn_size[2]) + (3 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "STATUS:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (4.5 * btn_size[2]) + (4 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "OUTPUT RES:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (5.5 * btn_size[2]) + (5 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "OUTPUT Hz:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (6.5 * btn_size[2]) + (6 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "ENGINE FPS:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (7.5 * btn_size[2]) + (7 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "ACTIVITY:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {0, (8.5 * btn_size[2]) + (8 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "NETMASK:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (1.5 * btn_size[2]) + (1 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "SERIAL NO:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (2.5 * btn_size[2]) + (2 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "BEE TYPE:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (3.5 * btn_size[2]) + (3 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "FILE COUNT:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (4.5 * btn_size[2]) + (4 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "FREE SPACE:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (5.5 * btn_size[2]) + (5 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "CPU POWER:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (6.5 * btn_size[2]) + (6 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    table.insert(
      graphics,
      {
        Type = "Text",
        Text = "SYNC STATUS:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Regular",
        HTextAlign = "Right",
        Color = Colors.control_label,
        Position = {6 * btn_size[1], (7.5 * btn_size[2]) + (7 * btn_gap[2])},
        Size = {3 * btn_size[1], btn_size[2]}
      }
    )
    layout["online"] = {
      PrettyName = "System~Online",
      Style = "Indicator",
      Color = {0, 255, 0},
      Position = {3 * btn_size[1], (0.5 * btn_size[2]) + (0 * btn_gap[2])},
      Size = {btn_size[2], btn_size[2]}
    }
    layout["ip_address"] = {
      PrettyName = "System~IP Address",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (1.5 * btn_size[2]) + (1 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["device_name"] = {
      PrettyName = "System~Device Name",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (2.5 * btn_size[2]) + (2 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["version"] = {
      PrettyName = "System~Version",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (3.5 * btn_size[2]) + (3 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["status"] = {
      PrettyName = "System~Status",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (4.5 * btn_size[2]) + (4 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["output_resolution"] = {
      PrettyName = "System~Output Resolution",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (5.5 * btn_size[2]) + (5 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["output_framerate"] = {
      PrettyName = "System~Output Framerate",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (6.5 * btn_size[2]) + (6 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["engine_fps"] = {
      PrettyName = "System~Engine FPS",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (7.5 * btn_size[2]) + (7 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["activity"] = {
      PrettyName = "System~Engine FPS",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.hive_yellow,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {3 * btn_size[1], (8.5 * btn_size[2]) + (8 * btn_gap[2])},
      Size = {9 * btn_size[1], btn_size[2]}
    }
    layout["netmask"] = {
      PrettyName = "System~NetMask",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (1.5 * btn_size[2]) + (1 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["serial"] = {
      PrettyName = "System~Serial Number",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (2.5 * btn_size[2]) + (2 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["bee_type"] = {
      PrettyName = "System~Bee Type",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (3.5 * btn_size[2]) + (3 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["file_count"] = {
      PrettyName = "System~Media File Count",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (4.5 * btn_size[2]) + (4 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["free_space"] = {
      PrettyName = "System~Free Storage Space",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (5.5 * btn_size[2]) + (5 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["cpu_power"] = {
      PrettyName = "System~CPU Power",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (6.5 * btn_size[2]) + (6 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
    layout["sync_status"] = {
      PrettyName = "System~Beesync Status",
      Style = "TextBox",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 12,
      StrokeWidth = 1,
      Position = {9 * btn_size[1], (7.5 * btn_size[2]) + (7 * btn_gap[2])},
      Size = {3 * btn_size[1], btn_size[2]}
    }
  elseif CurrentPage:sub(1, 6) == "Layer " then
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
  elseif CurrentPage == "Modules" then
    table.insert(
      graphics,
      {
        Type = "GroupBox",
        Text = "Enable Disable",
        HTextAlign = "Left",
        CornerRadius = 8,
        Fill = Colors.hive_grey,
        StrokeWidth = 1,
        Position = {0, 0},
        Size = module_enable_groupbox_size
      }
    )
    table.insert(
      graphics,
      {
        Type = "GroupBox",
        Text = "Playlist Functions",
        HTextAlign = "Left",
        CornerRadius = 8,
        Fill = Colors.hive_grey,
        StrokeWidth = 1,
        Position = {0, module_enable_groupbox_size[2] + 4},
        Size = module_playlist_groupbox_size
      }
    )
    layout["playlist_enable"] = {
      PrettyName = "Modules~Playlist Enable",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = "Flat",
      Color = Colors.Enabled,
      OffColor = Colors.control_background_light,
      UnlinkOffColor = true,
      TextColor = Colors.White,
      StrokeColor = Colors.contro_text,
      Legend = "Playlist",
      FontSize = 12,
      StrokeWidth = 1,
      Padding = 0,
      Margin = 0,
      Position = { (2 * btn_gap[1]), btn_size[2]},
      Size = {3 * btn_size[1],  btn_size[2]}
    }
    layout["l1_timecode_enable"] = {
      PrettyName = "Modules~Layer 1 TC Cuelist Enable",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = "Flat",
      Color = Colors.Enabled,
      OffColor = Colors.control_background_light,
      UnlinkOffColor = true,
      TextColor = Colors.White,
      StrokeColor = Colors.contro_text,
      Legend = "L1 TC Cuelist",
      FontSize = 12,
      StrokeWidth = 1,
      Padding = 0,
      Margin = 0,
      Position = {(3 * btn_size[1]) +  (4 * btn_gap[1]), btn_size[2]},
      Size = {3 * btn_size[1],  btn_size[2]}
    }
    layout["l2_timecode_enable"] = {
      PrettyName = "Modules~Layer 2 TC Cuelist Enable",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = "Flat",
      Color = Colors.Enabled,
      OffColor = Colors.control_background_light,
      UnlinkOffColor = true,
      TextColor = Colors.White,
      StrokeColor = Colors.contro_text,
      Legend = "L2 TC Cuelist",
      FontSize = 12,
      StrokeWidth = 1,
      Padding = 0,
      Margin = 0,
      Position = {(6 * btn_size[1]) +  (6* btn_gap[1]), btn_size[2]},
      Size = {3 * btn_size[1],  btn_size[2]}
    }
    layout["timeline_enable"] = {
      PrettyName = "Modules~Timeline Enable",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = "Flat",
      Color = Colors.Enabled,
      OffColor = Colors.control_background_light,
      UnlinkOffColor = true,
      TextColor = Colors.White,
      StrokeColor = Colors.contro_text,
      Legend = "Timeline",
      FontSize = 12,
      StrokeWidth = 1,
      Padding = 0,
      Margin = 0,
      Position = {(9 * btn_size[1]) +  (8* btn_gap[1]), btn_size[2]},
      Size = {3 * btn_size[1],  btn_size[2]}
    }
    layout["schedule_enable"] = {
      PrettyName = "Modules~Schedule Enable",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = "Flat",
      Color = Colors.Enabled,
      OffColor = Colors.control_background_light,
      UnlinkOffColor = true,
      TextColor = Colors.White,
      StrokeColor = Colors.contro_text,
      Legend = "Scheduler",
      FontSize = 12,
      StrokeWidth = 1,
      Padding = 0,
      Margin = 0,
      Position = {(12 * btn_size[1]) +  (10* btn_gap[1]), btn_size[2]},
      Size = {3 * btn_size[1],  btn_size[2]}
    }

  elseif CurrentPage == "About" then
  end
end
