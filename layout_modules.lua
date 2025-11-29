table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Enable Disable",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = moduleEnableGroupboxSize
  }
)
table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "Playlist Functions",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, moduleEnableGroupboxSize[2] + 4},
    Size = modulePlaylistGroupboxSize
  }
)

table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "System",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, moduleEnableGroupboxSize[2] + modulePlaylistGroupboxSize[2] + 8},
    Size = moduleSystemGroupboxSize
  }
)

layout["PlaylistEnable"] = {
  PrettyName = "Modules~Playlist Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "Playlist",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(2 * btnGap[1]), btnSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["L1TimecodeEnable"] = {
  PrettyName = "Modules~Layer 1 TC Cuelist Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "L1 TC Cuelist",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(3 * btnSize[1]) + (4 * btnGap[1]), btnSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["L2TimecodeEnable"] = {
  PrettyName = "Modules~Layer 2 TC Cuelist Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "L2 TC Cuelist",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(6 * btnSize[1]) + (6 * btnGap[1]), btnSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["TimelineEnable"] = {
  PrettyName = "Modules~Timeline Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "Timeline",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(9 * btnSize[1]) + (8 * btnGap[1]), btnSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}
layout["ScheduleEnable"] = {
  PrettyName = "Modules~Schedule Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "Scheduler",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(12 * btnSize[1]) + (10 * btnGap[1]), btnSize[2]},
  Size = {3 * btnSize[1], btnSize[2]}
}

table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Playlist Rows:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      (0 * btnSize[1]) + (1 * btnGap[1]),
      (1 * btnGap[2]) + moduleEnableGroupboxSize[2] + (1 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)
table.insert(
  graphics,
  {
    Type = "Text",
    Text = "Current Row:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      (0 * btnSize[1]) + (1 * btnGap[1]),
      (2 * btnGap[2]) + moduleEnableGroupboxSize[2] + (2 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)
table.insert(
  graphics,
  {
    Type = "Text",
    Text = "L1 TC Rows:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      (0 * btnSize[1]) + (1 * btnGap[1]),
      (3 * btnGap[2]) + moduleEnableGroupboxSize[2] + (3 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)
table.insert(
  graphics,
  {
    Type = "Text",
    Text = "L2 TC Rows:",
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Regular",
    HTextAlign = "Right",
    Color = Colors.ControlLabel,
    Position = {
      (0 * btnSize[1]) + (1 * btnGap[1]),
      (4 * btnGap[2]) + moduleEnableGroupboxSize[2] + (4 * btnSize[2])
    },
    Size = {3 * btnSize[1], btnSize[2]}
  }
)

layout["PlaylistRows"] = {
  PrettyName = "Modules~Playlist Rows",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btnSize[1]) + (1 * btnGap[1]),
    (1 * btnGap[2]) + moduleEnableGroupboxSize[2] + (1 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistCurrentRow"] = {
  PrettyName = "Modules~Playlist Current Row",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btnSize[1]) + (1 * btnGap[1]),
    (2 * btnGap[2]) + moduleEnableGroupboxSize[2] + (2 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["L1TCRows"] = {
  PrettyName = "Modules~Layer 1 Cue List Rows",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btnSize[1]) + (1 * btnGap[1]),
    (3 * btnGap[2]) + moduleEnableGroupboxSize[2] + (3 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["L2TCRows"] = {
  PrettyName = "Modules~Layer 2 Cue List Rows",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btnSize[1]) + (1 * btnGap[1]),
    (4 * btnGap[2]) + moduleEnableGroupboxSize[2] + (4 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistPlayPrevious"] = {
  PrettyName = "Modules~Playlist Play Previous",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "<< Previous",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (9 * btnSize[1]) + (3 * btnGap[1]),
    (1 * btnGap[2]) + moduleEnableGroupboxSize[2] + (1 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistPlayNext"] = {
  PrettyName = "Modules~Playlist Play Next",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "Next >>",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (12 * btnSize[1]) + (4 * btnGap[1]),
    (1 * btnGap[2]) + moduleEnableGroupboxSize[2] + (1 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistPlayFirst"] = {
  PrettyName = "Modules~Playlist Play First",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "<<<< First",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (9 * btnSize[1]) + (3 * btnGap[1]),
    (2 * btnGap[2]) + moduleEnableGroupboxSize[2] + (2 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistPlayLast"] = {
  PrettyName = "Modules~Playlist Play Last",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "Last >>>>",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (12 * btnSize[1]) + (4 * btnGap[1]),
    (2 * btnGap[2]) + moduleEnableGroupboxSize[2] + (2 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistPlayRow"] = {
  PrettyName = "Modules~Playlist Play Row",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "Play Row",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (9 * btnSize[1]) + (3 * btnGap[1]),
    (3 * btnGap[2]) + moduleEnableGroupboxSize[2] + (3 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["PlaylistPlayRowIndex"] = {
  PrettyName = "Modules~Playlist Play Row Index",
  Style = "TextBox",
  Color = Colors.ControlBackground,
  TextColor = Colors.ControlText,
  StrokeColor = Colors.ControlText,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (12 * btnSize[1]) + (4 * btnGap[1]),
    (3 * btnGap[2]) + moduleEnableGroupboxSize[2] + (3 * btnSize[2])
  },
  Size = {3 * btnSize[1], btnSize[2]}
}

layout["SystemRestart"] = {
  PrettyName = "System~Reboot Device",
  Style = "Button",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "REBOOT DEVICE",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (2 * btnSize[1]) + (4 * btnGap[1]),
    (6 * btnGap[2]) + moduleEnableGroupboxSize[2] + modulePlaylistGroupboxSize[2]
  },
  Size = {4 * btnSize[1], btnSize[2]}
}
layout["SystemShutdown"] = {
  PrettyName = "System~Shutdown Device",
  Style = "Button",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "SHUTDOWN DEVICE",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (6 * btnSize[1]) + (8 * btnGap[1]),
    (6 * btnGap[2]) + moduleEnableGroupboxSize[2] + modulePlaylistGroupboxSize[2]
  },
  Size = {4 * btnSize[1], btnSize[2]}
}

layout["SystemWake"] = {
  PrettyName = "System~Wake Device",
  Style = "Button",
  ButtonVisualStyle = "Flat",
  Color = Colors.EnableGreen,
  OffColor = Colors.ControlBackgroundLight,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.ControlText,
  Legend = "WAKE DEVICE",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (10 * btnSize[1]) + (12 * btnGap[1]),
    (6 * btnGap[2]) + moduleEnableGroupboxSize[2] + modulePlaylistGroupboxSize[2]
  },
  Size = {4 * btnSize[1], btnSize[2]}
}
