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
local cornerRadius = 0
local columnSize = math.ceil(layerItemCount / 2)
local btnSize = {32, 24}
local btnGap = {4, 4}
local hiveHeaderSize = {12.5 * btnSize[1], 120}
local headerSize = {12.5 * btnSize[1], 20}

local previewSize = {90, 50}
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

-- Add Hive header on every page
table.insert(
  graphics,
  {
    Type = "GroupBox",
    HTextAlign = "Left",
    CornerRadius = cornerRadius,
    Fill = Colors.HiveGrey,
    StrokeWidth = 1,
    Position = {0, 0},
    Size = hiveHeaderSize
  }
)
local logo = '--[[ #encode "images\HiveLogo.png" ]]'
table.insert(
  graphics,
  {
    Type = "Image",
    Position = {80, 10},
    Size = {240, 100},
    Image = logo,
  }
)

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
