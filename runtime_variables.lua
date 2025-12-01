-- This script is automatically loaded by the main script to define and initialize runtime variables

---- These variables can be changed during runtime
fileList = {}
fileListNames = {}
selectedFile = {}
selectedFolder = 0
fileMetadataList = {}
playMode = {}
seekTimerList = {}
seekLastValue = {}
playlistRowCount = 0
playlistActiveRow = 1
deiceSettings = nil
engineFps = 0
deviceInfo = nil

for i = 1, layerCount do
  playMode[i] = "In Frame"
  selectedFile[i] = 0
  savedPlayMode = {}
  seekTimerList[i] = Timer.New()
end

mediaItemCount = Properties["Media List Count"].Value

folderList = {
  ["MEDIA"] = 0
}

folderChoices = {}
for k, v in pairs(folderList) do
  table.insert(folderChoices, k)
end

lutList = {
  ["NONE"] = 0
}
lutChoices = {}
for k, v in pairs(lutList) do
  table.insert(lutChoices, k)
end

-- Key and Value arrays to be used with all ENUM based controls, separating the keys and values
-- is the easiest way to maintain order but still allow them to be edited if required

-- Play Mode
playModeKeys = {
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

playModeValues = {
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
transitionModeKeys = {
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

transitionModeValues = {
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
framingModeKeys = {
  "Letterbox",
  "Crop",
  "Stretch",
  "Multi Letterbox",
  "Centered"
}

framingModeValues = {
  0,
  1,
  2,
  3,
  4
}

-- Blend Mode
blendModeKeys = {
  "Alpha",
  "Additive",
  "Multiply",
  "Difference",
  "Screen",
  "Preserve Luma",
  "Rectangle Wipe",
  "Triangle Wipe"
}

blendModeValues = {
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
fxKeys = {
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

fxValues = {
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
StatusState = {
  OK = 0,
  COMPROMISED = 1,
  FAULT = 2,
  NOTPRESENT = 3,
  MISSING = 4,
  INITIALIZING = 5
}

ticker = 1

ipAddress = Properties["IP Address"].Value

-- Utility functions to get key from value and vice versa in the ENUM tables
function GetTableKey(tblKeys, tblValues, value)
  for i = 1, #tblValues do
    if tblValues[i] == value then
      return tblKeys[i]
    end
  end
  return nil
end

function GetTableValue(tblKeys, tblValues, key)
  for i = 1, #tblKeys do
    if tblKeys[i] == key then
      return tblValues[i]
    end
  end
  return nil
end
