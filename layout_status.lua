table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = statusHeaderSize
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
    Position = {0, 0 + statusHeaderSize[2] + btnGap[2]},
    Size = statusGroupboxSize
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
    Text = "STATUS:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.control_label,
    Position = {0, (0.5 * btnSize[2]) + (1 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (1.5 * btnSize[2]) + (2 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (2.5 * btnSize[2]) + (3 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (3.5 * btnSize[2]) + (4 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
  }
)
table.insert(
  graphics,
  {
    Type = "Text",
    Text = "UNIVERSE:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.control_label,
    Position = {0, (4.5 * btnSize[2]) + (5 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (5.5 * btnSize[2]) + (6 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (6.5 * btnSize[2]) + (7 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (7.5 * btnSize[2]) + (8 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {0, (8.5 * btnSize[2]) + (9 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (1.5 * btnSize[2]) + (2 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (2.5 * btnSize[2]) + (3 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (3.5 * btnSize[2]) + (4 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (4.5 * btnSize[2]) + (5 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (5.5 * btnSize[2]) + (6 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (6.5 * btnSize[2]) + (7 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
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
    Position = {6 * btnSize[1], (7.5 * btnSize[2]) + (8 * btnGap[2]) + statusHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
  }
)

layout["Status"] = {
  PrettyName = "System~Status",
  Style = "TextBox",
  Position = {3 * btnSize[1], (0.5 * btnSize[2]) + (1 * btnGap[2]) + statusHeaderSize[2]},
  Size = {9 * btnSize[1], btnSize[2]}
}

layout["IPAddress"] = {
  PrettyName = "System~IP Address",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (1.5 * btnSize[2]) + (2 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["DeviceName"] = {
  PrettyName = "System~Device Name",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (2.5 * btnSize[2]) + (3 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["Universe"] = {
  PrettyName = "System~Universe",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (4.5 * btnSize[2]) + (5 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["Version"] = {
  PrettyName = "System~Version",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (3.5 * btnSize[2]) + (4 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["OutputResolution"] = {
  PrettyName = "System~Output Resolution",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (5.5 * btnSize[2]) + (6 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["OutputFramerate"] = {
  PrettyName = "System~Output Framerate",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (6.5 * btnSize[2]) + (7 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["EngineFPS"] = {
  PrettyName = "System~Engine FPS",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (7.5 * btnSize[2]) + (8 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["Activity"] = {
  PrettyName = "System~Engine FPS",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.hive_yellow,
  StrokeColor = Colors.control_text,
  FontSize = 8,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (8.5 * btnSize[2]) + (9 * btnGap[2]) + statusHeaderSize[2]},
  Size = {9 * btnSize[1], btnSize[2]}
}
layout["Netmask"] = {
  PrettyName = "System~NetMask",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (1.5 * btnSize[2]) + (2 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["SerialNumber"] = {
  PrettyName = "System~Serial Number",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (2.5 * btnSize[2]) + (3 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["BeeType"] = {
  PrettyName = "System~Bee Type",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (3.5 * btnSize[2]) + (4 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["FileCount"] = {
  PrettyName = "System~Media File Count",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (4.5 * btnSize[2]) + (5 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["FreeSpace"] = {
  PrettyName = "System~Free Storage Space",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (5.5 * btnSize[2]) + (6 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["CpuPower"] = {
  PrettyName = "System~CPU Power",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (6.5 * btnSize[2]) + (7 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["SyncStatus"] = {
  PrettyName = "System~Beesync Status",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (7.5 * btnSize[2]) + (8 * btnGap[2]) + statusHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}