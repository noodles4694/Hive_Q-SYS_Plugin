-- we need to re-create the page list as it is nullified when entering this call
CreatePages()

-- function to count matching entries in a table
local function countMatches(tbl, conditions)
    local count = 0
    for _, obj in ipairs(tbl) do
        local ok = true
        for key, value in pairs(conditions) do
            if obj[key] ~= value then
                ok = false
                break
            end
        end
        if ok then
            count = count + 1
        end
    end
    return count
end

-- common variables used by each page layout
local CurrentPage = PageNames[props["page_index"].Value]
local media_item_count = props["Media List Count"].Value
local layerItemCount = countMatches(control_list, {Group = "Layer", Display = true})
local FX1ItemCount = countMatches(control_list, {Group = "FX1", Display = true})
local FX2ItemCount = countMatches(control_list, {Group = "FX2", Display = true})
local column_size = 12
local fx1_column_size = 6
local fx2_column_size = 6
local btn_size = {32, 24}
local btn_gap = {4, 4}
local status_header_size = {12.5 * btn_size[1], 120}
local status_groupbox_size = {12.5 * btn_size[1], 11 * btn_size[2]}
local player_groupbox_position = {0, 0}
local player_groupbox_size = {
  (((math.floor((layerItemCount / column_size)) + 1) * 6) + 1) * btn_size[1],
  (column_size + 2) * btn_size[2]
}
local fx1_groupbox_size = {
  (((math.floor((FX1ItemCount / fx1_column_size))) * 6) + 1) * btn_size[1],
  (fx1_column_size + 2) * btn_size[2]
}
local fx2_groupbox_size = {
  (((math.floor((FX2ItemCount / fx2_column_size))) * 6) + 1) * btn_size[1],
  (fx2_column_size + 2) * btn_size[2]
}
local preview_size = {2.4 * btn_size[1], (1.35 * btn_size[1])}
local preview_groupbox_size = {
  (layer_count * preview_size[1]) + (4 * layer_count) + 8 + (3 * btn_size[1]),
  (2 * preview_size[2]) + 8
}
local media_list_groupbox_size = {
  (layer_count * preview_size[1]) + (4 * layer_count) + 8 + (3 * btn_size[1]),
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
  elseif CurrentPage == "Preview" then
  --[[ #include "layout_preview.lua" ]]
  end

  -- pin only controls - not displayed
  layout["PreviewEnable"] = {
    PrettyName = "System~Preview Enable",
    Style = "None",
    Color = Colors.control_background,
    TextColor = Colors.control_text,
    StrokeColor = Colors.control_text,
    FontSize = 8,
    StrokeWidth = 1,
    Position = {
      0,
      0
    },
    Size = {5, 5}
  }

  layout["LogMessage"] = {
    PrettyName = "System~Log Message",
    Style = "None",
    Position = {
      0,
      0
    },
    Size = {5, 5}
  }

  -- add the JSON Data pins only if they are enabled in properties
  if (props["Enable JSON Data Pins (WARNING)"].Value == "Enabled") then
    layout["SettingsJSON"] = {
      PrettyName = "JSON Data~Settings",
      Style = "None",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {
        0,
        0
      },
      Size = {5, 5}
    }
    layout["MappingJSON"] = {
      PrettyName = "JSON Data~Mapping",
      Style = "None",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {
        0,
        0
      },
      Size = {5, 5}
    }
    layout["PlaylistJSON"] = {
      PrettyName = "JSON Data~Playlist",
      Style = "None",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {
        0,
        0
      },
      Size = {5, 5}
    }
    layout["TimecodeJSON"] = {
      PrettyName = "JSON Data~Timecode",
      Style = "None",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {
        0,
        0
      },
      Size = {5, 5}
    }
    layout["TimelineJSON"] = {
      PrettyName = "JSON Data~Timeline",
      Style = "None",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {
        0,
        0
      },
      Size = {5, 5}
    }
    layout["SchedulerJSON"] = {
      PrettyName = "JSON Data~Scheduler",
      Style = "None",
      Color = Colors.control_background,
      TextColor = Colors.control_text,
      StrokeColor = Colors.control_text,
      FontSize = 8,
      StrokeWidth = 1,
      Position = {
        0,
        0
      },
      Size = {5, 5}
    }
  end
end
