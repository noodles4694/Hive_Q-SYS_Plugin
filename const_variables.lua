local udp_port = 8083
local layer_count = 2
local max_media_items = 120

local Colors = {
  hive_yellow = {255, 215, 0},
  hive_grey = {56, 56, 59},
  White = {255, 255, 255},
  Black = {0, 0, 0},
  Red = {255, 0, 0},
  Green = {0, 255, 0},
  transparent = {0, 0, 0, 0},
  control_label = {0, 0, 0}
}

local control_list = {
  ["File Select"] = {
    Name = "file_select_",
    ControlType = "Text",
    Style = "ComboBox",
    PinStyle = "Both",
    UserPin = true
  },
  ["Time Elapsed"] = {
    Name = "time_elapsed_",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  },
  ["Duration"] = {
    Name = "duration_",
    ControlType = "Indicator",
    IndicatorType = "Text",
    PinStyle = "Output",
    UserPin = true
  },
  ["Seek"] = {
    Name = "seek_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Fader",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Intensity"] = {
    Name = "intensity_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["In Frame"] = {
    Name = "in_frame_",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    Min = 0,
    Max = 9999999,
    PinStyle = "Both",
    UserPin = true
  },
  ["Out Frame"] = {
    Name = "out_frame_",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    Min = 0,
    Max = 9999999,
    PinStyle = "Both",
    UserPin = true
  },
  ["Play Mode"] = {
    Name = "play_mode_",
    ControlType = "Text",
    Style = "ComboBox",
    PinStyle = "Both",
    UserPin = true
  },
  ["Framing Mode"] = {
    Name = "framing_mode_",
    ControlType = "Text",
    Style = "ComboBox",
    PinStyle = "Both",
    UserPin = true
  },
  ["Blend Mode"] = {
    Name = "blend_mode_",
    ControlType = "Text",
    Style = "ComboBox",
    PinStyle = "Both",
    UserPin = true
  },
  --[[["LUT Select"] = {
    Name = "lut_select_",
    ControlType = "Text",
    Style = "ComboBox",
    PinStyle = "Both",
    UserPin = true
  },]]
  ["Play Speed"] = {
    Name = "play_speed_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 1000,
    PinStyle = "Both",
    UserPin = true
  },
  ["Move Speed"] = {
    Name = "move_speed_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["MTC Hour"] = {
    Name = "mtc_hour_",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    Min = 0,
    Max = 23,
    PinStyle = "Both",
    UserPin = true
  },
  ["MTC Minute"] = {
    Name = "mtc_minute_",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    Min = 0,
    Max = 59,
    PinStyle = "Both",
    UserPin = true
  },
  ["MTC Second"] = {
    Name = "mtc_second_",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    Min = 0,
    Max = 59,
    PinStyle = "Both",
    UserPin = true
  },
  ["MTC Frame"] = {
    Name = "mtc_frame_",
    ControlType = "Knob",
    ControlUnit = "Integer",
    Style = "Text Field",
    Min = 0,
    Max = 59,
    PinStyle = "Both",
    UserPin = true
  },
  ["Scale"] = {
    Name = "scale_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 1000,
    PinStyle = "Both",
    UserPin = true
  },
  ["Aspect Ratio"] = {
    Name = "aspect_ratio_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Position X"] = {
    Name = "position_x_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Position Y"] = {
    Name = "position_y_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Rotation X"] = {
    Name = "rotation_x_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -1440,
    Max = 1440,
    PinStyle = "Both",
    UserPin = true
  },
  ["Rotation Y"] = {
    Name = "rotation_y_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -1440,
    Max = 1440,
    PinStyle = "Both",
    UserPin = true
  },
  ["Rotation Z"] = {
    Name = "rotation_z_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -1440,
    Max = 1440,
    PinStyle = "Both",
    UserPin = true
  },
  ["Red"] = {
    Name = "red_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Green"] = {
    Name = "green_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Blue"] = {
    Name = "blue_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Hue"] = {
    Name = "hue_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Saturation"] = {
    Name = "saturation_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Contrast"] = {
    Name = "contrast_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = -100,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Strobe"] = {
    Name = "strobe_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  },
  ["Volume"] = {
    Name = "volume_",
    ControlType = "Knob",
    ControlUnit = "Percent",
    Style = "Text Field",
    Min = 0,
    Max = 100,
    PinStyle = "Both",
    UserPin = true
  }
}

--[[ 
local parameter_list = {} -- this results in random order indexing
for k,v in pairs(control_list) do
  table.insert(parameter_list, k)
end
]]
local parameter_list = {
  "File Select",
  "Time Elapsed",
  "Duration",
  "Seek",
  "Intensity",
  "In Frame",
  "Out Frame",
  "Play Mode",
  "Framing Mode",
  "Blend Mode",
  --"LUT Select",
  "Play Speed",
  "Move Speed",
  "MTC Hour",
  "MTC Minute",
  "MTC Second",
  "MTC Frame",
  "Scale",
  "Aspect Ratio",
  "Position X",
  "Position Y",
  "Rotation X",
  "Rotation Y",
  "Rotation Z",
  "Red",
  "Green",
  "Blue",
  "Hue",
  "Saturation",
  "Contrast",
  "Strobe",
  "Volume"
}
