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
    print("Connecting to Hive WebSocket at " .. ipTarget)
    connectSocket(ipTarget)
  else
    print("No IP address provided for WebSocket connection.")
  end
end

-- Disconnect from the Hive WebSocket server
function Disconnect()
  shouldConnect = false
  ws:Close()
  wsConnected = false
  print("WebSocket connection closed")
  if connectionCallback then
    connectionCallback(false) -- Call the status callback with false to indicate disconnection
  end
  pingTimer:Stop()
end

-- WebSocket event handlers
ws.Connected = function()
  wsConnected = true
  print("WebSocket connection established")
  if connectionCallback then
    connectionCallback(true) -- Call the status callback with true to indicate success
  end
  -- send ping every 10 seconds to keep connection alive
  pingTimer:Start(10)
end

-- Handle WebSocket closure and attempt to reconnect if needed
ws.Closed = function()
  wsConnected = false
  print("WebSocket connection closed")
  if connectionCallback then
    connectionCallback(false) -- Call the status callback with false to indicate disconnection
  end
  pingTimer:Stop()
  if shouldConnect then
    if ipTarget then
      connectSocket(ipTarget) -- Attempt to reconnect
    else
      print("No IP address provided for reconnection.")
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
      print("No callback / handler found for data: ")
    end
    dataBuffer = "" -- Clear the buffer after processing
  end
end

-- Handle WebSocket errors
ws.Error = function(socket, err)
  print("Hive WebSocket error: " .. err)
  pingTimer:Stop()
  -- Attempt to reconnect if the connection is lost
  if wsConnected == false and shouldConnect == true then
    if ipTarget then
      connectSocket(ipTarget) -- Attempt to reconnect
    end
  end
end

-- Timer to send ping messages to keep the WebSocket connection alive
pingTimer.EventHandler = function()
  ws:Ping()
end

-- Function to connect to the WebSocket server
function connectSocket(ip)
  -- Check if the WebSocket is already connected
  if (wsConnected) then
    print("WebSocket is already connected.")
    ws:Close()
  end
  -- Connect to the Hive WebSocket server
  ws:Connect("ws", ip, "", 9002)
end

-- Handler for Watched Patch updates
function refreshView(refreshViewMessage)
  local callback = refreshViewMap[refreshViewMessage.Path]
  if callback then
    callback(refreshViewMessage.Path, refreshViewMessage.Value)
  else
    print("No callback found for refresh view message: " .. refreshViewMessage)
  end
end

-- Register the refreshView handler
handlers["RefreshView"] = refreshView

-- Function to remove a watch on a specific path
function _RemoveWatch(path)
  if (wsConnected) then
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
function removeWatch(path)
  if path then
    refreshViewMap[path] = nil
    _RemoveWatch(path)
    print("Removed watch for path: " .. path)
  end
end

-- Functions to get patch numerical values
function getPatchDouble(path, callback)
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
function setPatchDouble(path, value)
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
function _WatchPatchDouble(path)
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
function watchPatchDouble(path, callback)
  refreshViewMap[path] = callback
  _WatchPatchDouble(path)
  getPatchDouble(path, callback)
end

-- Public function to get patch string values
function getPatchString(path, callback)
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
function setPatchString(path, value)
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
function _WatchPatchString(path)
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
function watchPatchString(path, callback)
  refreshViewMap[path] = callback
  _WatchPatchString(path)
  getPatchString(path, callback)
end

-- Public function to get patch JSON values
function getPatchJSON(path, callback, raw)
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
function setPatchJSON(path, value)
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
function updatePatchJSON(path, value)
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
function _WatchPatchJSON(path)
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
function watchPatchJSON(path, callback)
  refreshViewMap[path] = callback
  _WatchPatchJSON(path)
  getPatchJSON(path, callback)
end
