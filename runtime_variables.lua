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

local play_mode_list = {
  ["In Frame"] = 0,
  ["Out Frame"] = 1,
  ["Loop Forward"] = 2,
  ["Loop Reverse"] = 3,
  ["Play Once Forward"] = 4,
  ["Play Once Reverse"] = 5,
  ["Stop"] = 6,
  ["Pause"] = 7,
  ["Bounce (Ping-Pong)"] = 8,
  ["Take Over Frame"] = 9,
  ["Loop Forward with pause on zero intensity"] = 10,
  ["Loop Reverse with pause on zero intensity"] = 11,
  ["Play Once Forward with pause on zero intensity"] = 12,
  ["Play Once Reverse with pause on zero intensity"] = 13,
  ["Bounce (Ping-Pong) with pause on zero intensity"] = 15,
  ["Synchronise to Time code"] = 20,
  ["Loop Forward with re-trigger on intensity"] = 40,
  ["Loop Reverse with re-trigger on intensity"] = 41,
  ["Play Once Forward with re-trigger on intensity"] = 42,
  ["Play Once Reverse with re-trigger on intensity"] = 43,
  ["Bounce with re-trigger on intensity"] = 45
}

local play_mode_choices = {}
for k, v in pairs(play_mode_list) do
  table.insert(play_mode_choices, k)
end

local transition_mode_list = {
  ["Alpha"] = 0,
  ["Additive"] = 1,
  ["Multiply"] = 2,
  ["Difference"] = 3,
  ["Screen"] = 4,
  ["Preserve Luma"] = 5,
  ["Rectangle Wipe"] = 6,
  ["Triangle Wipe"] = 7,
  ["Minimum"] = 8,
  ["Maximum"] = 9,
  ["Subtract"] = 10,
  ["Darken"] = 11,
  ["Lighten"] = 12,
  ["Soft Lighten"] = 13,
  ["Dark Lighten"] = 14,
  ["Exclusion"] = 15,
  ["Random"] = 16,
  ["Ripple"] = 17,
  ["Threshold"] = 18,
  ["Sine"] = 19,
  ["Invert Mask"] = 20,
  ["Noise"] = 21,
  ["Swirl"] = 22,
  ["Gradient"] = 23,
  ["Pixel Sort"] = 24,
  ["Checkerboard"] = 25,
  ["Pulse"] = 26,
  ["Hue Shift"] = 27,
  ["Fractal"] = 28,
  ["Waveform"] = 29,
  ["RGB Split"] = 30,
  ["Glitch"] = 31
}

local transition_mode_choices = {}
for k, v in pairs(transition_mode_list) do
  table.insert(transition_mode_choices, k)
end

local framing_mode_list = {
  ["Letterbox"] = 0,
  ["Crop"] = 1,
  ["Stretch"] = 2,
  ["Multi Letterbox"] = 3,
  ["Centered"] = 4
}

local framing_mode_choices = {}
for k, v in pairs(framing_mode_list) do
  table.insert(framing_mode_choices, k)
end

local blend_mode_list = {
  ["Alpha"] = 0,
  ["Additive"] = 1,
  ["Multiply"] = 2,
  ["Difference"] = 3,
  ["Screen"] = 4,
  ["Preserve Luma"] = 5,
  ["Rectangle Wipe"] = 6,
  ["Triangle Wipe"] = 7
}

local blend_mode_choices = {}
for k, v in pairs(blend_mode_list) do
  table.insert(blend_mode_choices, k)
end

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
local udp_command_base_string_set = 'localSVPatch.SetPatchDouble("/LAYER '
local udp_command_base_string_get = 'GetPatchDoubleWithDescriptor("/LAYER '
