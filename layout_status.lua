local statusTextboxSize = {headerSize[1]/2 - btnSize[1], btnSize[2]}
local statusGroupboxSize = {12.5 * btnSize[1], (15 * statusTextboxSize[2]) + (28 * btnGap[2]) + btnSize[2]}
local statusVerticalOffset = hiveHeaderSize[2] + btnGap[2]

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = hiveHeaderSize
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
    Type = "Header",
    HTextAlign = "Center",
    Text = "Setup",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, statusVerticalOffset},
    Size = headerSize
  }
)

statusVerticalOffset = statusVerticalOffset + headerSize[2] +  btnGap[2]

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1], 2 * btnSize[2]}
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
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset + (btnSize[2] / 2)},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)

layout["IPAddress"] = {
  PrettyName = "System~IP Address",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset + (btnSize[2] / 2)},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 * btnSize[2]) + btnGap[2]

table.insert(
  graphics,
  {
    Type = "Header",
    HTextAlign = "Center",
    Text = "Connection Status",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, statusVerticalOffset},
    Size = headerSize
  }
)

statusVerticalOffset = statusVerticalOffset + headerSize[2] +  btnGap[2]

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1], 2 * btnSize[2]}
  }
)

layout["Status"] = {
  PrettyName = "System~Status",
  Style = "TextBox",
  Position = {btnSize[1]*3, statusVerticalOffset + (btnSize[2] / 2)},
  Size = {headerSize[1] - (6 * btnSize[1]), btnSize[2]}
}

statusVerticalOffset = statusVerticalOffset +  (2 * btnSize[2]) + btnGap[2]

table.insert(
  graphics,
  {
    Type = "Header",
    HTextAlign = "Center",
    Text = "System Status",
    IsBold = true,
    CornerRadius = cornerRadius,
    Position = {0, statusVerticalOffset},
    Size = headerSize
  }
)

statusVerticalOffset = statusVerticalOffset + headerSize[2] +  btnGap[2]

table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, statusVerticalOffset},
    Size = statusGroupboxSize
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
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset + (btnSize[2] / 2)},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["DeviceName"] = {
  PrettyName = "System~Device Name",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset + (btnSize[2] / 2)},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (0.5 * btnSize[2]) + (2 * btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "MODEL:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["Model"] = {
  PrettyName = "System~Model",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "BEE TYPE:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["BeeType"] = {
  PrettyName = "System~Bee Type",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "UNIVERSE:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["Universe"] = {
  PrettyName = "System~Universe",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "SOFTWARE VERSION:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["Version"] = {
  PrettyName = "System~Version",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "SERIAL NUMBER:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["SerialNumber"] = {
  PrettyName = "System~Serial Number",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "MAC ADDRESS:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["MACAddress"] = {
  PrettyName = "System~MAC Address",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "OUTPUT RESOLUTION:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["OutputResolution"] = {
  PrettyName = "System~Output Resolution",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "OUTPUT Hz:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["OutputFramerate"] = {
  PrettyName = "System~Output Framerate",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "ENGINE FPS:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["EngineFPS"] = {
  PrettyName = "System~Engine FPS",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "FILE COUNT:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["FileCount"] = {
  PrettyName = "System~File Count",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "FREE SPACE:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["FreeSpace"] = {
  PrettyName = "System~Free Storage Space",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "CPU POWER:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["CpuPower"] = {
  PrettyName = "System~CPU Power",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "SYNC STATUS:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {headerSize[1] /2,  btnSize[2]}
  }
)
layout["SyncStatus"] = {
  PrettyName = "System~Sync Status",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {headerSize[1]/2, statusVerticalOffset},
  Size = statusTextboxSize
}

statusVerticalOffset = statusVerticalOffset +  (2 *btnGap[2]) + statusTextboxSize[2]

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "ACTIVITY:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, statusVerticalOffset},
    Size = {btnSize[1] * 2,  btnSize[2]}
  }
)
layout["Activity"] = {
  PrettyName = "System~Activity",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {btnSize[1] * 2, statusVerticalOffset},
  Size = {headerSize[1] - (3 * btnSize[1]), statusTextboxSize[2]}
}


--[[
table.insert(
  graphics,
  {
    Type = "Text",
    Text = "STATUS:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {0, (0.5 * btnSize[2]) + (1 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {0, (3.5 * btnSize[2]) + (4 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {0, (4.5 * btnSize[2]) + (5 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {0, (5.5 * btnSize[2]) + (6 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {0, (6.5 * btnSize[2]) + (7 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {0, (7.5 * btnSize[2]) + (8 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {0, (8.5 * btnSize[2]) + (9 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (1.5 * btnSize[2]) + (2 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (2.5 * btnSize[2]) + (3 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (3.5 * btnSize[2]) + (4 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (4.5 * btnSize[2]) + (5 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (5.5 * btnSize[2]) + (6 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (6.5 * btnSize[2]) + (7 * btnGap[2]) + hiveHeaderSize[2]},
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
    Color = Colors.ControlLabel,
    Position = {6 * btnSize[1], (7.5 * btnSize[2]) + (8 * btnGap[2]) + hiveHeaderSize[2]},
    Size = {3 * btnSize[1], btnSize[2]}
  }
)




layout["Universe"] = {
  PrettyName = "System~Universe",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (4.5 * btnSize[2]) + (5 * btnGap[2]) + hiveHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}




layout["Activity"] = {
  PrettyName = "System~Engine FPS",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.HiveYellow,
  StrokeColor = Colors.ControlText,
  FontSize = 8,
  StrokeWidth = 1,
  Position = {3 * btnSize[1], (8.5 * btnSize[2]) + (9 * btnGap[2]) + hiveHeaderSize[2]},
  Size = {9 * btnSize[1], btnSize[2]}
}
layout["Netmask"] = {
  PrettyName = "System~NetMask",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (1.5 * btnSize[2]) + (2 * btnGap[2]) + hiveHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["BeeType"] = {
  PrettyName = "System~Bee Type",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {9 * btnSize[1], (3.5 * btnSize[2]) + (4 * btnGap[2]) + hiveHeaderSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}





]]