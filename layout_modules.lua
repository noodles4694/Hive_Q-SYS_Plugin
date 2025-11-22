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

table.insert(
  graphics,
  {
    Type = "GroupBox",
    Text = "System",
    HTextAlign = "Left",
    CornerRadius = 8,
    Fill = Colors.hive_grey,
    StrokeWidth = 1,
    Position = {0, module_enable_groupbox_size[2] + module_playlist_groupbox_size[2] + 8},
    Size = module_system_groupbox_size
  }
)

layout["playlist_enable"] = {
  PrettyName = "Modules~Playlist Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "Playlist",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(2 * btn_gap[1]), btn_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["l1_timecode_enable"] = {
  PrettyName = "Modules~Layer 1 TC Cuelist Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "L1 TC Cuelist",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(3 * btn_size[1]) + (4 * btn_gap[1]), btn_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["l2_timecode_enable"] = {
  PrettyName = "Modules~Layer 2 TC Cuelist Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "L2 TC Cuelist",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(6 * btn_size[1]) + (6 * btn_gap[1]), btn_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
}
layout["timeline_enable"] = {
  PrettyName = "Modules~Timeline Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "Timeline",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(9 * btn_size[1]) + (8 * btn_gap[1]), btn_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
}
layout["schedule_enable"] = {
  PrettyName = "Modules~Schedule Enable",
  Style = "Button",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "Scheduler",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {(12 * btn_size[1]) + (10 * btn_gap[1]), btn_size[2]},
  Size = {3 * btn_size[1], btn_size[2]}
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
    Color = Colors.control_label,
    Position = {
      (0 * btn_size[1]) + (1 * btn_gap[1]),
      (1 * btn_gap[2]) + module_enable_groupbox_size[2] + (1 * btn_size[2])
    },
    Size = {3 * btn_size[1], btn_size[2]}
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
    Color = Colors.control_label,
    Position = {
      (0 * btn_size[1]) + (1 * btn_gap[1]),
      (2 * btn_gap[2]) + module_enable_groupbox_size[2] + (2 * btn_size[2])
    },
    Size = {3 * btn_size[1], btn_size[2]}
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
    Color = Colors.control_label,
    Position = {
      (0 * btn_size[1]) + (1 * btn_gap[1]),
      (3 * btn_gap[2]) + module_enable_groupbox_size[2] + (3 * btn_size[2])
    },
    Size = {3 * btn_size[1], btn_size[2]}
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
    Color = Colors.control_label,
    Position = {
      (0 * btn_size[1]) + (1 * btn_gap[1]),
      (4 * btn_gap[2]) + module_enable_groupbox_size[2] + (4 * btn_size[2])
    },
    Size = {3 * btn_size[1], btn_size[2]}
  }
)

layout["playlist_rows"] = {
  PrettyName = "Modules~Playlist Rows",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btn_size[1]) + (1 * btn_gap[1]),
    (1 * btn_gap[2]) + module_enable_groupbox_size[2] + (1 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["playlist_current_row"] = {
  PrettyName = "Modules~Playlist Current Row",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btn_size[1]) + (1 * btn_gap[1]),
    (2 * btn_gap[2]) + module_enable_groupbox_size[2] + (2 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["l1_tc_rows"] = {
  PrettyName = "Modules~Layer 1 Cue List Rows",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btn_size[1]) + (1 * btn_gap[1]),
    (3 * btn_gap[2]) + module_enable_groupbox_size[2] + (3 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}



layout["l2_tc_rows"] = {
  PrettyName = "Modules~Layer 2 Cue List Rows",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (3 * btn_size[1]) + (1 * btn_gap[1]),
    (4 * btn_gap[2]) + module_enable_groupbox_size[2] + (4 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}


layout["playlist_play_previous"] = {
  PrettyName = "Modules~Playlist Play Previous",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "<< Previous",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (9 * btn_size[1]) + (3 * btn_gap[1]),
    (1 * btn_gap[2]) + module_enable_groupbox_size[2] + (1 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["playlist_play_next"] = {
  PrettyName = "Modules~Playlist Play Next",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "Next >>",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (12 * btn_size[1]) + (4 * btn_gap[1]),
    (1 * btn_gap[2]) + module_enable_groupbox_size[2] + (1 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["playlist_play_first"] = {
  PrettyName = "Modules~Playlist Play First",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "<<<< First",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (9 * btn_size[1]) + (3 * btn_gap[1]),
    (2 * btn_gap[2]) + module_enable_groupbox_size[2] + (2 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["playlist_play_last"] = {
  PrettyName = "Modules~Playlist Play Last",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "Last >>>>",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (12 * btn_size[1]) + (4 * btn_gap[1]),
    (2 * btn_gap[2]) + module_enable_groupbox_size[2] + (2 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["playlist_play_row"] = {
  PrettyName = "Modules~Playlist Play Row",
  ButtonStyle = "Toggle",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "Play Row",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (9 * btn_size[1]) + (3 * btn_gap[1]),
    (3 * btn_gap[2]) + module_enable_groupbox_size[2] + (3 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}

layout["playlist_play_row_index"] = {
  PrettyName = "Modules~Playlist Play Row Index",
  Style = "TextBox",
  Color = Colors.control_background,
  TextColor = Colors.control_text,
  StrokeColor = Colors.control_text,
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (12 * btn_size[1]) + (4 * btn_gap[1]),
    (3 * btn_gap[2]) + module_enable_groupbox_size[2] + (3 * btn_size[2])
  },
  Size = {3 * btn_size[1], btn_size[2]}
}


layout["system_restart"] = {
  PrettyName = "System~Reboot Device",
  Style = "Button",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "REBOOT DEVICE",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (2 * btn_size[1]) + (4 * btn_gap[1]),
    (6 * btn_gap[2]) + module_enable_groupbox_size[2] + module_playlist_groupbox_size[2] 
  },
  Size = {4 * btn_size[1], btn_size[2]}
}
layout["system_shutdown"] = {
  PrettyName = "System~Shutdown Device",
  Style = "Button",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "SHUTDOWN DEVICE",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (6 * btn_size[1]) + (8 * btn_gap[1]),
    (6 * btn_gap[2]) + module_enable_groupbox_size[2] + module_playlist_groupbox_size[2] 
  },
  Size = {4 * btn_size[1], btn_size[2]}
}

layout["system_wake"] = {
  PrettyName = "System~Wake Device",
  Style = "Button",
  ButtonVisualStyle = "Flat",
  Color = Colors.enable_green,
  OffColor = Colors.control_background_light,
  UnlinkOffColor = true,
  TextColor = Colors.White,
  StrokeColor = Colors.control_text,
  Legend = "WAKE DEVICE",
  FontSize = 12,
  StrokeWidth = 1,
  Position = {
    (10 * btn_size[1]) + (12 * btn_gap[1]),
    (6 * btn_gap[2]) + module_enable_groupbox_size[2] + module_playlist_groupbox_size[2] 
  },
  Size = {4 * btn_size[1], btn_size[2]}
}
