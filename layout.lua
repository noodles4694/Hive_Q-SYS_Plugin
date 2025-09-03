CreatePages()

local CurrentPage = PageNames[props["page_index"].Value]
local media_item_count = props["Media List Count"].Value
local column_size = 12
local fx1_column_size = 6
local fx2_column_size = 6
local btn_size = {32, 24}
local btn_gap = {4, 4}
local status_header_size = {12.5 * btn_size[1], 120}
local status_groupbox_size = {12.5 * btn_size[1], 11 * btn_size[2]}
local player_groupbox_position = {0, 0}
local player_groupbox_size = {
  (((math.floor((#parameter_list / column_size)) + 1) * 6) + 1) * btn_size[1],
  (column_size + 2) * btn_size[2]
}
local fx1_groupbox_size = {
  (((math.floor((#fx1_list / fx1_column_size))) * 6) + 1) * btn_size[1],
  (fx1_column_size + 2) * btn_size[2]
}
local fx2_groupbox_size = {
  (((math.floor((#fx2_list / fx2_column_size))) * 6) + 1) * btn_size[1],
  (fx2_column_size + 2) * btn_size[2]
}
local preview_size = {2.4 * btn_size[1], (1.35 * btn_size[1])}
local media_list_groupbox_size = {
  (2 * preview_size[1]) + 12 + (3 * btn_size[1]),
  ((media_item_count + 1) * preview_size[2]) + 8
}
local module_enable_groupbox_size = {(16 * btn_size[1]) + (4 * btn_gap[1]), (2 * btn_size[2]) + (2 * btn_gap[2])}
local module_playlist_groupbox_size = {(16 * btn_size[1]) + (4 * btn_gap[1]), (6 * btn_size[2]) + (2 * btn_gap[2])}
local module_system_groupbox_size = {(16 * btn_size[1]) + (4 * btn_gap[1]), (2 * btn_size[2]) + (2 * btn_gap[2])}

if CurrentPage then
  if CurrentPage == "Status" then
--[[ #include "layout_status.lua" ]]
  elseif CurrentPage:sub(1, 6) == "Layer " then
--[[ #include "layout_layers.lua" ]]
  elseif CurrentPage == "Media" then
--[[ #include "layout_media.lua" ]]
  elseif CurrentPage == "Modules" then
--[[ #include "layout_modules.lua" ]]
  end
end
