-- Information block for the plugin
--[[ #include "info.lua" ]]
--[[ #include "const_variables.lua" ]]
-- Define the color of the plugin object in the design
function GetColor(props)
  return Colors.hive_yellow
end

-- The name that will initially display when dragged into a design
function GetPrettyName(props)
  if
    props["Model"] == nil or props["Model"].Value == "PLUTO" or props["Model"].Value == "OSMIA" or
      props["Model"].Value == "MINIMA" or
      props["Model"].Value == "NEXUS"
   then
    return "Hive Beeblade" .. string.char(10) .. props["Model"].Value .. string.char(10) .. props["IP Address"].Value
  else
    return "Hive" .. string.char(10) .. props["Model"].Value .. string.char(10) .. props["IP Address"].Value
  end
end

-- Optional function used if plugin has multiple pages
PageNames = {}
function CreatePages()
  PageNames = {"Status"}
  for i = 1, layer_count do
    table.insert(PageNames, "Layer " .. i)
  end
  table.insert(PageNames, "Media")
  table.insert(PageNames, "Modules")
  table.insert(PageNames, "Preview")
end

function GetPages(props)
  local pages = {}
  --[[ #include "pages.lua" ]]
  return pages
end

-- Optional function to define model if plugin supports more than one model
function GetModel(props)
  local model = {}
  --[[ #include "model.lua" ]]
  return model
end

-- Define User configurable Properties of the plugin
function GetProperties()
  local props = {}
  --[[ #include "properties.lua" ]]
  return props
end

-- Optional function to define pins on the plugin that are not connected to a Control
function GetPins(props)
  local pins = {}
  --[[ #include "pins.lua" ]]
  return pins
end

-- Optional function to update available properties when properties are altered by the user
function RectifyProperties(props)
  --[[ #include "rectify_properties.lua" ]]
  return props
end

-- Optional function to define components used within the plugin
function GetComponents(props)
  local components = {}
  --[[ #include "components.lua" ]]
  return components
end

-- Optional function to define wiring of components used within the plugin
function GetWiring(props)
  local wiring = {}
  --[[ #include "wiring.lua" ]]
  return wiring
end

-- Defines the Controls used within the plugin
function GetControls(props)
  local ctrls = {}
  --[[ #include "controls.lua" ]]
  return ctrls
end

--Layout of controls and graphics for the plugin UI to display
function GetControlLayout(props)
  local layout = {}
  local graphics = {}
  --[[ #include "layout.lua" ]]
  return layout, graphics
end

--Start event based logic
if Controls then
--[[ #include "runtime_variables.lua"]]
--[[ #include "runtime_utility_functions.lua"]]
--[[ #include "runtime_hivefunctions.lua"]]
--[[ #include "runtime.lua" ]]
--[[ #include "runtime_commandfunctions.lua"]]
--[[ #include "runtime_event_handlers.lua"]]
end
