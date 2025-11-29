# Hive Q-SYS Plugin Development Guide

## Project Overview

This is a **Q-SYS Designer plugin** (Lua-based) for controlling Hive Beeblade, Beebox, and Nexus media players. The plugin uses a **modular include-based architecture** where `plugin.lua` orchestrates multiple Lua files that are compiled into a single `.qplug` file.

## Critical Architecture Patterns

### Include-Based Module System

The plugin uses preprocessor-style `#include` directives to compose functionality:

```lua
--[[ #include "info.lua" ]]
--[[ #include "const_variables.lua" ]]
```

**Key module files:**

- `plugin.lua` - Main orchestrator with Q-SYS lifecycle functions
- `info.lua` - Plugin metadata (name, version, GUID)
- `const_variables.lua` - Global constants (`layerCount`, `Colors`, `control_list`)
- `properties.lua` - User-configurable plugin properties
- `controls.lua` - Control definitions (pins, indicators, buttons)
- `layout*.lua` - UI layout files (status, layers, media, modules, preview)
- `runtime*.lua` - Event handlers, WebSocket communication, Hive API functions

### Q-SYS Plugin Lifecycle Functions

The plugin implements standard Q-SYS callbacks:

- `GetColor(props)` - Plugin object color in designer
- `GetPrettyName(props)` - Display name with IP address
- `GetProperties()` - User-editable properties
- `GetControls(props)` - Control definitions (pins/indicators)
- `GetControlLayout(props)` - UI layout and graphics
- `GetPages(props)` - Multi-page navigation
- Runtime logic in `if Controls then` block (only executes when deployed)

### Control List Pattern

`const_variables.lua` defines a comprehensive `control_list` table that drives dynamic control generation:

```lua
local control_list = {
  [1] = {
    Name = "FileSelect",
    Path = "FILE SELECT",
    ControlType = "Text",
    Watch = true,
    Display = true,
    UserPin = true
  }
}
```

This single-source-of-truth drives control creation, layout positioning, and WebSocket parameter watching.

## Build & Compile Workflow

### Build Process

**Use the default build task:** `Ctrl+Shift+B` or run task "Compile QSD Plugin"

The build chain has 3 dependent tasks:

1. **`-`** - Increments version in `info.lua` via `compile_plugin.sh`
2. **`--`** - Compiles includes into `.qplug` via `PLUGCC.exe`
3. **`Compile QSD Plugin`** - Copies `.qplug` to Q-SYS Designer plugins folder at `%USERPROFILE%\Documents\QSC\Q-Sys Designer\Plugins\`

### Version Management

Build version increments are controlled by shell script input:

- `ver_dev` - Increment development number (default)
- `ver_fix` - Increment fix number
- `ver_min` - Increment minor number
- `ver_maj` - Increment major number
- `ver_none` - No version increment

## WebSocket Communication

### Hive Device Protocol

The plugin communicates with Hive devices via WebSocket (see `runtime_hivefunctions.lua`):

- Uses `rapidjson` library for JSON encoding/decoding
- Implements request/response pattern with sequence numbers
- Path-based parameter system (e.g., `/LAYER 1/FILE SELECT/Value`)
- Supports `Get`, `Set`, `Watch` commands for parameter monitoring

**Key functions:**

- `Connect(ip, statusCallback)` - Establish WebSocket connection
- `GetPatchJSON(path, callback)` - Retrieve JSON data
- `SetPatchDouble(path, value, callback)` - Set numeric parameters
- `WatchPatchDouble(path, callback)` - Subscribe to parameter changes

## UI Layout System

### Dynamic Layout Generation

Layout files (`layout_*.lua`) dynamically calculate positioning based on:

- `layerCount` - Number of video layers (typically 2)
- `mediaItemCount` - User-configured media list size
- `control_list` - Controls filtered by `Group` and `Display` properties

Layout uses grid-based positioning with `btnSize` and `btnGap` constants for consistent spacing.

### Page Structure

Multi-page UI defined by `CreatePages()`:

- Status page - Device info and connection status
- Layer pages - Per-layer controls (file selection, playback, effects)
- Media page - Media library browser
- Modules page - Device module configuration
- Preview page - Video output preview (if enabled)

## Common Development Tasks

### Adding a New Control

1. Add entry to `control_list` in `const_variables.lua`
2. Control automatically appears in `controls.lua` generation
3. Layout updates dynamically in corresponding `layout_*.lua`
4. Add event handler in `runtime_event_handlers.lua`
5. Implement command function in `runtime_commandfunctions.lua`

### Modifying Device Models

Update `properties.lua` enum choices and handle model-specific logic in `rectify_properties.lua` (currently unused) or runtime code.

### Debugging

- Set `ShowDebug = true` in `info.lua` to enable debug logging
- Use `LogDebug()`, `LogMessage()`, `LogError()` functions
- Monitor Q-SYS Designer debug output when plugin is deployed

## Key Files Reference

- **Core plugin:** `plugin.lua`, `info.lua`
- **Configuration:** `const_variables.lua`, `properties.lua`
- **WebSocket API:** `runtime_hivefunctions.lua`
- **Device control:** `runtime_commandfunctions.lua`
- **Event handling:** `runtime_event_handlers.lua`
- **UI:** `layout.lua` + `layout_*.lua` files
- **Build tools:** `plugincompile/PLUGCC.exe`, `compile_plugin.sh`, `copy_plugin.cmd`

## Coding Conventions

- Use `local` for variables within module scope
- Global constants in `const_variables.lua` are NOT prefixed with `local` (shared across includes)
- Control names use PascalCase (e.g., `FileSelect`, `PlayMode`)
- Hive API paths use UPPERCASE (e.g., `/LAYER 1/FILE SELECT/Value`)
- Event handlers assigned via `Controls.ControlName.EventHandler = function() ... end`
