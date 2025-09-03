table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = status_header_size
  }
)
table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Setup",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {0, 0 + status_header_size[2] + btn_gap[2]},
    Size = status_groupbox_size
  }
)
local logo = '--[[ #encode "images\HiveLogo.png" ]]'
table.insert(
  graphics,
  {
    Type = "Image",
    Position = {80, 10},
    Size = {240, 100},
    Image = logo,
  }
)
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
    Position = {0, (0.5 * btn_size[2]) + (1 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (1.5 * btn_size[2]) + (2 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (2.5 * btn_size[2]) + (3 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (3.5 * btn_size[2]) + (4 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (4.5 * btn_size[2]) + (5 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (5.5 * btn_size[2]) + (6 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (6.5 * btn_size[2]) + (7 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (7.5 * btn_size[2]) + (8 * btn_gap[2]) + status_header_size[2]},
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
    Position = {0, (8.5 * btn_size[2]) + (9 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (1.5 * btn_size[2]) + (2 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (2.5 * btn_size[2]) + (3 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (3.5 * btn_size[2]) + (4 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (4.5 * btn_size[2]) + (5 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (5.5 * btn_size[2]) + (6 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (6.5 * btn_size[2]) + (7 * btn_gap[2]) + status_header_size[2]},
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
    Position = {6 * btn_size[1], (7.5 * btn_size[2]) + (8 * btn_gap[2]) + status_header_size[2]},
    Size = {3 * btn_size[1], btn_size[2]}
  }
)
layout["online"] = {
  PrettyName = "System~Online",
  Style = "Indicator",
  Color = {0, 255, 0},
  Position = {3 * btn_size[1], (0.5 * btn_size[2]) + (1 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (1.5 * btn_size[2]) + (2 * btn_gap[2]) + status_header_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
}
layout["device_name"] = {
  PrettyName = "System~Device Name",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  StrokeWidth = 1,
  Position = {3 * btn_size[1], (2.5 * btn_size[2]) + (3 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (3.5 * btn_size[2]) + (4 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (4.5 * btn_size[2]) + (5 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (5.5 * btn_size[2]) + (6 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (6.5 * btn_size[2]) + (7 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (7.5 * btn_size[2]) + (8 * btn_gap[2]) + status_header_size[2]},
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
  Position = {3 * btn_size[1], (8.5 * btn_size[2]) + (9 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (1.5 * btn_size[2]) + (2 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (2.5 * btn_size[2]) + (3 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (3.5 * btn_size[2]) + (4 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (4.5 * btn_size[2]) + (5 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (5.5 * btn_size[2]) + (6 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (6.5 * btn_size[2]) + (7 * btn_gap[2]) + status_header_size[2]},
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
  Position = {9 * btn_size[1], (7.5 * btn_size[2]) + (8 * btn_gap[2]) + status_header_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
}