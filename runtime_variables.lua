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
  ["Play Once Reverse with re-trigger on intensity"] = 43
}

local play_mode_choices = {}
for k, v in pairs(play_mode_list) do
  table.insert(play_mode_choices, k)
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
  ["Preserve Luma"] = 5
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
--local udp_command_base_string_get = 'WatchPatchDouble("/LAYER '
