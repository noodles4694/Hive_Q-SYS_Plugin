local file_list = {}
local selected_file = {}
local file_metadata_list = {}
local play_mode = {}
local seek_timer_list = {}
local seek_last_value = {}

for i = 1, layer_count do
  play_mode[i] = "In Frame"
  selected_file[i] = ""
  saved_play_mode = {}
  seek_timer_list[i] = Timer.New()
end

local media_item_count = Properties["Media List Count"].Value

local folder_list = {
  ["MEDIA"] = 0
}

local folder_choices = {}
for k, v in pairs(folder_list) do
  table.insert(folder_choices, k)
end

local lut_list = {
  ["NONE"] = 0
}
local lut_choices = {}
for k, v in pairs(lut_list) do
  table.insert(lut_choices, k)
end

-- Key and Value arrays to be used with all ENUM based controls, separating the keys and values
-- is the easiest way to maintain order

local play_mode_keys = {
  "In Frame",
  "Out Frame",
  "Loop Forward",
  "Loop Reverse",
  "Play Once Forward",
  "Play Once Reverse",
  "Stop",
  "Pause",
  "Bounce (Ping-Pong)",
  "Take Over Frame",
  "Loop Forward with pause on zero intensity",
  "Loop Reverse with pause on zero intensity",
  "Play Once Forward with pause on zero intensity",
  "Play Once Reverse with pause on zero intensity",
  "Bounce (Ping-Pong) with pause on zero intensity",
  "Synchronise to Time code",
  "Loop Forward with re-trigger on intensity",
  "Loop Reverse with re-trigger on intensity",
  "Play Once Forward with re-trigger on intensity",
  "Play Once Reverse with re-trigger on intensity",
  "Bounce with re-trigger on intensity"
}

local play_mode_values = {
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  15,
  20,
  40,
  41,
  42,
  43,
  45
}

local transition_mode_keys = {
  "Alpha",
  "Additive",
  "Multiply",
  "Difference",
  "Screen",
  "Preserve Luma",
  "Rectangle Wipe",
  "Triangle Wipe",
  "Minimum",
  "Maximum",
  "Subtract",
  "Darken",
  "Lighten",
  "Soft Lighten",
  "Dark Lighten",
  "Exclusion",
  "Random",
  "Ripple",
  "Threshold",
  "Sine",
  "Invert Mask",
  "Noise",
  "Swirl",
  "Gradient",
  "Pixel Sort",
  "Checkerboard",
  "Pulse",
  "Hue Shift",
  "Fractal",
  "Waveform",
  "RGB Split",
  "Glitch"
}

local transition_mode_values = {
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31
}

local framing_mode_keys = {
  "Letterbox",
  "Crop",
  "Stretch",
  "Multi Letterbox",
  "Centered"
}

local framing_mode_values = {
  0,
  1,
  2,
  3,
  4
}

local blend_mode_keys = {
  "Alpha",
  "Additive",
  "Multiply",
  "Difference",
  "Screen",
  "Preserve Luma",
  "Rectangle Wipe",
  "Triangle Wipe"
}

local blend_mode_values = {
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7
}

local fx_list = {
  ["NONE"] = 0,
  ["OLD TV"] = 1,
  ["SEPIA"] = 2,
  ["FEEDBACK"] = 3,
  ["BLUR"] = 4,
  ["CRYSTALISE"] = 5,
  ["FRACTAL SOUP"] = 6,
  ["RADAR"] = 7,
  ["PIXELISE"] = 8,
  ["SOFT EDGE OVAL"] = 9,
  ["TILE"] = 10,
  ["INFINITY ZOOM"] = 11,
  ["DOT GRID"] = 12,
  ["KALEIDOSCOPE"] = 13,
  ["MULTI MIRROR"] = 14,
  ["REBELLE DISTORT"] = 15
}

local fXParameters = {
  fx = {
    {
      effectName = "0 - NONE",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "1 - OLD TV",
      param = {
        {paramName = "X POSITION"},
        {paramName = "Y POSITION"},
        {paramName = "X SCALE"},
        {paramName = "Y SCALE"},
        {paramName = "SATURATION"},
        {paramName = "CONTRAST"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "2 - SEPIA",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "3 - FEEDBACK",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "SCALE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "4 - BLUR",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "QUALITY"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "5 - CRYSTALISE",
      param = {
        {paramName = "CRYSTAL SIZE"},
        {paramName = "SPEED"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "6 - FRACTAL SOUP",
      param = {
        {paramName = "HUE"},
        {paramName = "SATURATION"},
        {paramName = "BRIGHTNESS"},
        {paramName = "SPEED"},
        {paramName = "MODE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "7 - RADAR",
      param = {
        {paramName = "SPEED"},
        {paramName = "X POSITION"},
        {paramName = "Y POSITION"},
        {paramName = "SCALE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "8 - PIXELISE",
      param = {
        {paramName = "PIXELATION"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "9 - SOFT EDGE OVAL",
      param = {
        {paramName = "X POSITION"},
        {paramName = "Y POSITION"},
        {paramName = "SIZE X"},
        {paramName = "SIZE Y"},
        {paramName = "SOFTNESS"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "10 - TILE",
      param = {
        {paramName = "HORIZONTAL"},
        {paramName = "VERTICAL"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "11 - INFINITY ZOOM",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "12 - DOT GRID",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "DOT SIZE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "13 - KALEIDOSCOPE",
      param = {
        {paramName = "DIVISIONS"},
        {paramName = "ROTATION"},
        {paramName = "ZOOM"},
        {paramName = "X POSITION"},
        {paramName = "Y POSITION"},
        {paramName = "IN ANGLE"},
        {paramName = "ROTATE SPD"},
        {paramName = "X POS SPD"},
        {paramName = "Y POS SPD"},
        {paramName = "IN ANGLE SPD"},
        {paramName = "X POS QTY"},
        {paramName = "Y POS QTY"},
        {paramName = "IN ANGLE QTY"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "14 - MULTI MIRROR",
      param = {
        {paramName = "X POSITION"},
        {paramName = "Y POSITION"},
        {paramName = "X OFFSET"},
        {paramName = "Y OFFSET"},
        {paramName = "X MIRROR"},
        {paramName = "Y MIRROR"},
        {paramName = "ROTATE HI"},
        {paramName = "ROTATE LO"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "15 - REBELLE DISTORT",
      param = {
        {paramName = "SCAN LINES"},
        {paramName = "NOISE"},
        {paramName = "STATIC"},
        {paramName = "FUZZ"},
        {paramName = "RGB"},
        {paramName = "SCAN OPTION"},
        {paramName = "JERK"},
        {paramName = "MOVE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "16 - 4 POINT WARP",
      param = {
        {paramName = "TOP LEFT X"},
        {paramName = "TOP LEFT Y"},
        {paramName = "TOP RIGHT X"},
        {paramName = "TOP RIGHT Y"},
        {paramName = "BOTTOM RIGHT X"},
        {paramName = "BOTTOM RIGHT Y"},
        {paramName = "BOTTOM LEFT X"},
        {paramName = "BOTTOM LEFT Y"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "17 - HALF TONE",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "ANGLE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "18 - HALF TONE INV",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "ANGLE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "19 - HALF TONE COL",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "ANGLE"},
        {paramName = "OFFSET"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "20 - HALF TONE SMP",
      param = {
        {paramName = "AMOUNT"},
        {paramName = "ANGLE"},
        {paramName = "OFFSET"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "21 - SWIRL DISTORT",
      param = {
        {paramName = "NOISE"},
        {paramName = "SWIRL"},
        {paramName = "TONE"},
        {paramName = "ROTATE SPD"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "22 - GLITCH SPLIT",
      param = {
        {paramName = "GLITCH"},
        {paramName = "SPLIT"},
        {paramName = "STROBE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "23 - BURN MELT NOISE",
      param = {
        {paramName = "BURN"},
        {paramName = "MELT"},
        {paramName = "NOISE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "24 - SHATTER",
      param = {
        {paramName = "CRACK"},
        {paramName = "SHATTER"},
        {paramName = "SIZE"},
        {paramName = "ANIM SPEED"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "25 - MULTI NOISE",
      param = {
        {paramName = "NOISE 1"},
        {paramName = "NOISE 2"},
        {paramName = "CONTRAST"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "26 - KALEIDO POP",
      param = {
        {paramName = "GLOW"},
        {paramName = "KALEIDOSCOPE"},
        {paramName = "SPARKLE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "27 - PRISM MIRAGE",
      param = {
        {paramName = "GLOW"},
        {paramName = "CHROMA"},
        {paramName = "REFRACT"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "28 - BLOCK PRISM",
      param = {
        {paramName = "BLOCK SIZE"},
        {paramName = "CHROMA"},
        {paramName = "BLOCK JUMBLE"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "29 - SQUARE CLOUD",
      param = {
        {paramName = "SATURATION"},
        {paramName = "MULTIPLY"},
        {paramName = "GLOW"},
        {paramName = "SPEED"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "30 - CIRCLE PARTY",
      param = {
        {paramName = "CIRCLE COUNT"},
        {paramName = "GLOW"},
        {paramName = "ROT SPEED"},
        {paramName = "TINT"},
        {paramName = "CIRCLE SIZE"},
        {paramName = "RING COUNT"},
        {paramName = "PHASE"},
        {paramName = "SPACING"},
        {paramName = "OFFSET"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "31 - EQ TUNNEL",
      param = {
        {paramName = "SPEED"},
        {paramName = "EQ POINTS"},
        {paramName = "ROTATE SPEED"},
        {paramName = "EQ MOTION"},
        {paramName = "SATURATION"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "32 - ELECTRO PATTERN",
      param = {
        {paramName = "SPEED"},
        {paramName = "ITERATIONS"},
        {paramName = "ZOOM"},
        {paramName = "ROTATION SPEED"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "33 - 4 POINT MASK",
      param = {
        {paramName = "TOP LEFT X"},
        {paramName = "TOP LEFT Y"},
        {paramName = "TOP RIGHT X"},
        {paramName = "TOP RIGHT Y"},
        {paramName = "BOTTOM RIGHT X"},
        {paramName = "BOTTOM RIGHT Y"},
        {paramName = "BOTTOM LEFT X"},
        {paramName = "BOTTOM LEFT Y"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "34 - 8 POINT MASK",
      param = {
        {paramName = "P1 X"},
        {paramName = "P1 Y"},
        {paramName = "P2 X"},
        {paramName = "P2 Y"},
        {paramName = "P3 X"},
        {paramName = "P3 Y"},
        {paramName = "P4 X"},
        {paramName = "P4 Y"},
        {paramName = "P5 X"},
        {paramName = "P5 Y"},
        {paramName = "P6 X"},
        {paramName = "P6 Y"},
        {paramName = "P7 X"},
        {paramName = "P7 Y"},
        {paramName = "P8 X"},
        {paramName = "P8 Y"}
      }
    },
    {
      effectName = "35 - Effect 35",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "36 - Effect 36",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "37 - Effect 37",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "38 - Effect 38",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "39 - Effect 39",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    },
    {
      effectName = "40 - Effect 40",
      param = {
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"},
        {paramName = "-"}
      }
    }
  }
}

local fx_choices = {}
for k, v in pairs(fx_list) do
  table.insert(fx_choices, k)
end

ticker = 1
poll_parameter_list = {}
for _, v in pairs(parameter_list) do
  if v ~= "Time Elapsed" and v ~= "Duration" and v ~= "Seek" then
    table.insert(poll_parameter_list, v:upper())
  end
end

local ip_address = Properties["IP Address"].Value

function get_table_key(tblKeys, tblValues, value)
  for i = 1, #tblValues do
    if tblValues[i] == value then
      return tblKeys[i]
    end
  end
  return nil
end

function get_table_value(tblKeys, tblValues, key)
  for i = 1, #tblKeys do
    if tblKeys[i] == key then
      return tblValues[i]
    end
  end
  return nil
end
