-- we need to re-create the page list as it is nullified when entering this call
CreatePages()

-- Count matching entries in a table
local function CountMatches(tbl, conditions)
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
local mediaItemCount = props["Media List Count"].Value
local layerItemCount = CountMatches(control_list, {Group = "Layer", Display = true})
local FX1ItemCount = CountMatches(control_list, {Group = "FX1", Display = true})
local FX2ItemCount = CountMatches(control_list, {Group = "FX2", Display = true})
local columnSize = 12
local fx1ColumnSize = 6
local fx2ColumnSize = 6
local btnSize = {32, 24}
local btnGap = {4, 4}
local statusHeaderSize = {12.5 * btnSize[1], 120}
local statusGroupboxSize = {12.5 * btnSize[1], 11 * btnSize[2]}
local playerGroupboxPosition = {0, 0}
local playerGroupboxSize = {
  (((math.floor((layerItemCount / columnSize)) + 1) * 6) + 1) * btnSize[1],
  (columnSize + 2) * btnSize[2]
}
local fx1GroupboxSize = {
  (((math.floor((FX1ItemCount / fx1ColumnSize))) * 6) + 1) * btnSize[1],
  (fx1ColumnSize + 2) * btnSize[2]
}
local fx2GroupboxSize = {
  (((math.floor((FX2ItemCount / fx2ColumnSize))) * 6) + 1) * btnSize[1],
  (fx2ColumnSize + 2) * btnSize[2]
}
local previewSize = {2.4 * btnSize[1], (1.35 * btnSize[1])}
local previewGroupboxSize = {
  (layerCount * previewSize[1]) + (4 * layerCount) + 8 + (3 * btnSize[1]),
  (2 * previewSize[2]) + 8
}
local mediaListGroupboxSize = {
  (layerCount * previewSize[1]) + (4 * layerCount) + 8 + (3 * btnSize[1]),
  ((mediaItemCount + 1) * previewSize[2]) + 8
}
local moduleEnableGroupboxSize = {(16 * btnSize[1]) + (4 * btnGap[1]), (2 * btnSize[2]) + (2 * btnGap[2])}
local modulePlaylistGroupboxSize = {(16 * btnSize[1]) + (4 * btnGap[1]), (6 * btnSize[2]) + (2 * btnGap[2])}
local moduleSystemGroupboxSize = {(16 * btnSize[1]) + (4 * btnGap[1]), (2 * btnSize[2]) + (2 * btnGap[2])}

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
    Color = Colors.ControlBackground,
    TextColor = Colors.ControlText,
    StrokeColor = Colors.ControlText,
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
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      StrokeColor = Colors.ControlText,
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
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      StrokeColor = Colors.ControlText,
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
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      StrokeColor = Colors.ControlText,
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
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      StrokeColor = Colors.ControlText,
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
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      StrokeColor = Colors.ControlText,
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
      Color = Colors.ControlBackground,
      TextColor = Colors.ControlText,
      StrokeColor = Colors.ControlText,
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
