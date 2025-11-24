-- This script is automatically loaded by the main script to define and initialize runtime variables

---- These variables can be changed during runtime
local file_list = {}
local file_list_names = {}
local selected_file = {}
local file_metadata_list = {}
local play_mode = {}
local seek_timer_list = {}
local seek_last_value = {}
local playlist_row_count = 0
local playlist_active_row = 1

for i = 1, layer_count do
  play_mode[i] = "In Frame"
  selected_file[i] = 0
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
-- is the easiest way to maintain order but still allow them to be edited if required

-- Play Mode
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

-- Transition Mode
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

-- Framing Mode
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

-- Blend Mode
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

-- FX
local fx_keys = {
  "NONE",
  "OLD TV",
  "SEPIA",
  "FEEDBACK",
  "BLUR",
  "CRYSTALISE",
  "FRACTAL SOUP",
  "RADAR",
  "PIXELISE",
  "SOFT EDGE OVAL",
  "TILE",
  "INFINITY ZOOM",
  "DOT GRID",
  "KALEIDOSCOPE",
  "MULTI MIRROR",
  "REBELLE DISTORT",
  "4 POINT WARP",
  "HALF TONE",
  "HALF TONE INV",
  "HALF TONE COL",
  "HALF TONE SMP",
  "SWIRL DISTORT",
  "GLITCH SPLIT",
  "BURN MELT NOISE",
  "SHATTER",
  "MULTI NOISE",
  "KALEIDO POP",
  "PRISM MIRAGE",
  "BLOCK PRISM",
  "SQUARE CLOUD",
  "CIRCLE PARTY",
  "EQ TUNNEL",
  "ELECTRO PATTERN",
  "4 POINT MASK",
  "8 POINT MASK",
  "Effect 35",
  "Effect 36",
  "Effect 37",
  "Effect 38",
  "Effect 39",
  "Effect 40"
}

local fx_values = {
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
  31,
  32,
  33,
  34,
  35,
  36,
  37,
  38,
  39,
  40
}

  -- Q-SYS standard status states
  local StatusState = {
    OK          = 0,
    COMPROMISED = 1,
    FAULT       = 2,
    NOTPRESENT  = 3,
    MISSING     = 4,
    INITIALIZING= 5
  }

ticker = 1
poll_parameter_list = {}
for _, v in pairs(parameter_list) do
  if v ~= "Time Elapsed" and v ~= "Duration" and v ~= "Seek" then
    table.insert(poll_parameter_list, v:upper())
  end
end

local ip_address = Properties["IP Address"].Value

-- Utility functions to get key from value and vice versa in the ENUM tables
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
