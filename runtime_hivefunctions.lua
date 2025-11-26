-- Description: Functions to interact with Hive via WebSocket

-- Load the RapidJSON library for JSON encoding/decoding
rapidjson = require("rapidjson")

-- Load the WebSocket library
ws = WebSocket.New()

-- Variables to manage WebSocket connection and callbacks
local wsConnected = false
local sequenceNo = 0
local pendingCallbacks = {}
local pendingRawCallbacks = {}
local refreshViewMap = {}
local handlers = {}
local connectionCallback = nil
local pingTimer = Timer.New()
local ipTarget = nil
local shouldConnect = false
local dataBuffer = "" -- Buffer to hold incoming data

-- Connect to the Hive WebSocket server
function Connect(ip, statusCallback)
  connectionCallback = statusCallback
  shouldConnect = true
  ipTarget = ip
  if (ipTarget) then
    FnLogMessage("Connecting to Hive Device at " .. ipTarget)
    ConnectSocket(ipTarget)
  else
    FnLogError("No IP address provided for Device connection.")
  end
end

-- Disconnect from the Hive WebSocket server
function Disconnect()
  shouldConnect = false
  ws:Close()
  wsConnected = false
  FnLogMessage("Hive connection closed")
  if connectionCallback then
    connectionCallback(false, "Connection Closed") -- Call the status callback with false to indicate disconnection
  end
  pingTimer:Stop()
end

-- WebSocket event handlers
ws.Connected = function()
  wsConnected = true
  FnLogMessage("Hive connection established")
  if connectionCallback then
    connectionCallback(true, "Online") -- Call the status callback with true to indicate success
  end
  -- send ping every 10 seconds to keep connection alive
  pingTimer:Start(10)
end

-- Handle WebSocket closure and attempt to reconnect if needed
ws.Closed = function()
  wsConnected = false
  FnLogMessage("Hive connection closed")
  if connectionCallback then
    connectionCallback(false, "Connection Closed") -- Call the status callback with false to indicate disconnection
  end
  pingTimer:Stop()
  if shouldConnect then
    if ipTarget then
      FnLogMessage("Attempting to reconnect to Hive Device at " .. ipTarget)
      if connectionCallback then
        connectionCallback(false, "Offline - Attempting to reconnect") -- Call the status callback with false to indicate disconnection
      end
      ConnectSocket(ipTarget) -- Attempt to reconnect
    else
      FnLogError("No IP address provided for reconnection.")
    end
  end
end

-- Handle incoming data from the WebSocket
ws.Data = function(ws, data)
  -- Check if the data is a complete message or part of a larger message
  if (string.len(data) == 16384) then
    dataBuffer = dataBuffer .. data
  else
    -- data is complete, let's process it
    dataBuffer = dataBuffer .. data
    local response = rapidjson.decode(dataBuffer)
    local callback = nil
    -- check if we have a local handler that matches the response name
    if response and response.apiVersion == 1 and response.name and handlers[response.name] then
      -- check if we have a defined handler for this data
      callback = handlers[response.name]
      if callback then
        -- Call the handler with the response data
        callback(response.ret)
      end
    elseif response and response.apiVersion == 1 and response.sequence and pendingCallbacks[response.sequence] then
      callback = pendingCallbacks[response.sequence]
      if callback then
        -- Call the callback with the response data
        callback(response.args.Path, response.ret.Value)
        -- remove the callback from pendingCallbacks after it's called
        pendingCallbacks[response.sequence] = nil
      end
    elseif response and response.apiVersion == 1 and response.sequence and pendingRawCallbacks[response.sequence] then
      callback = pendingRawCallbacks[response.sequence]
      if callback then
        -- Call the callback with the response data
        callback(response.args.Path, dataBuffer)
        -- remove the callback from pendingCallbacks after it's called
        pendingRawCallbacks[response.sequence] = nil
      end
    else
      FnLogError("No callback / handler found for data: ")
    end
    dataBuffer = "" -- Clear the buffer after processing
  end
end

-- Handle WebSocket errors
ws.Error = function(socket, err)
  FnLogError("Hive connection error: " .. err)
  pingTimer:Stop()
  -- Attempt to reconnect if the connection is lost
  if wsConnected == false and shouldConnect == true then
    if ipTarget then
      FnLogMessage("Attempting to reconnect to Hive Device at " .. ipTarget)
      if connectionCallback then
        connectionCallback(false, "Offline - Attempting to reconnect") -- Call the status callback with false to indicate disconnection
      end
      ConnectSocket(ipTarget) -- Attempt to reconnect
    end
  end
end

-- Timer to send ping messages to keep the WebSocket connection alive
pingTimer.EventHandler = function()
  FnLogDebug("Sending ping to Hive")
  ws:Ping()
end

-- Function to connect to the WebSocket server
function ConnectSocket(ip)
  -- Check if the WebSocket is already connected
  if (wsConnected) then
    FnLogMessage("WebSocket is already connected.")
    ws:Close()
  end
  -- Connect to the Hive WebSocket server
  FnLogDebug("Connecting to Hive WebSocket at " .. ip)
  ws:Connect("ws", ip, "", 9002)
end

-- Handler for Watched Patch updates
function RefreshView(refreshViewMessage)
  local callback = refreshViewMap[refreshViewMessage.Path]
  if callback then
    callback(refreshViewMessage.Path, refreshViewMessage.Value)
  else
    FnLogError("No callback found for refresh view message: " .. refreshViewMessage)
  end
end

-- Register the RefreshView handler
handlers["RefreshView"] = RefreshView

-- Function to remove a watch on a specific path
function RemoveWatchInternal(path)
  if (wsConnected) then
    FnLogDebug("Removing watch for path: " .. path)
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "_RemoveWatch",
      args = {Path = path}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to remove a watch and its associated callback
function RemoveWatch(path)
  if path then
    refreshViewMap[path] = nil
    RemoveWatchInternal(path)
    print("Removed watch for path: " .. path)
  end
end

-- Functions to get patch numerical values
function GetPatchDouble(path, callback)
  if (wsConnected) then
    -- Increment the sequence number for each request
    sequenceNo = sequenceNo + 1
    if sequenceNo > 99999 then
      sequenceNo = 1 -- Reset sequence number if it exceeds 99999
    end
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "GetPatchDouble",
      args = {Path = path},
      sequence = sequenceNo
    }
    -- Store the callback for later use
    pendingCallbacks[sequenceNo] = callback
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end
-- Functions to set patch numerical values
function SetPatchDouble(path, value)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "SetPatchDouble",
      args = {Path = path, Value = value}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Functions to watch for changes to patch numerical values
function WatchPatchDoubleInternal(path)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "_WatchPatchDouble",
      args = {Path = path}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to watch a patch numerical value and set up its callback
function WatchPatchDouble(path, callback)
  refreshViewMap[path] = callback
  WatchPatchDoubleInternal(path)
  GetPatchDouble(path, callback)
end

-- Public function to get patch string values
function GetPatchString(path, callback)
  if (wsConnected) then
    -- Increment the sequence number for each request
    sequenceNo = sequenceNo + 1
    if sequenceNo > 99999 then
      sequenceNo = 1 -- Reset sequence number if it exceeds 99999
    end
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "GetPatchString",
      args = {Path = path},
      sequence = sequenceNo
    }
    -- Store the callback for later use
    pendingCallbacks[sequenceNo] = callback
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to set patch string values
function SetPatchString(path, value)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "SetPatchString",
      args = {Path = path, Value = value}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Function to watch changes to patch string values
function WatchPatchStringInternal(path)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "_WatchPatchString",
      args = {Path = path}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to watch a patch string value and set up its callback
function WatchPatchString(path, callback)
  refreshViewMap[path] = callback
  WatchPatchStringInternal(path)
  GetPatchString(path, callback)
end

-- Public function to get patch JSON values
function GetPatchJSON(path, callback, raw)
  if (wsConnected) then
    -- Increment the sequence number for each request
    sequenceNo = sequenceNo + 1
    if sequenceNo > 99999 then
      sequenceNo = 1 -- Reset sequence number if it exceeds 99999
    end
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "GetPatchJSON",
      args = {Path = path},
      sequence = sequenceNo
    }
    -- Store the callback for later use
    if raw then
      pendingRawCallbacks[sequenceNo] = callback
    else
      pendingCallbacks[sequenceNo] = callback
    end
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to set patch JSON values
function SetPatchJSON(path, value)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "SetPatchJSON",
      args = {Path = path, Value = value}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to update patch JSON values
function UpdatePatchJSON(path, value)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "UpdatePatchJSON",
      args = {Path = path, Value = value}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Function to watch changes to patch JSON values
function WatchPatchJSONInternal(path)
  if (wsConnected) then
    -- Create the request object
    local request = {
      apiVersion = 1,
      name = "_WatchPatchJSON",
      args = {Path = path}
    }
    -- Send the request over the WebSocket
    ws:Write(rapidjson.encode(request), false)
  end
end

-- Public function to watch a patch JSON value and set up its callback
function WatchPatchJSON(path, callback)
  refreshViewMap[path] = callback
  WatchPatchJSONInternal(path)
  GetPatchJSON(path, callback)
end
