rapidjson = require("rapidjson")

ws = WebSocket.New()
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

function connectSocket(ip)
  -- Check if the WebSocket is already connected
  if (wsConnected) then
    print("WebSocket is already connected.")
    ws:Close()
  end
  -- Connect to the Hive WebSocket server
  ws:Connect("ws", ip, "", 9002)
end

function refreshView(refreshViewMessage)
  local callback = refreshViewMap[refreshViewMessage.Path]
  if callback then
    callback(refreshViewMessage.Path, refreshViewMessage.Value)
  else
    print("No callback found for refresh view message: " .. refreshViewMessage)
  end
end

handlers["RefreshView"] = refreshView

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

function removeWatch(path)
  if path then
    refreshViewMap[path] = nil
    _RemoveWatch(path)
    print("Removed watch for path: " .. path)
  end
end

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

function watchPatchDouble(path, callback)
  refreshViewMap[path] = callback
  _WatchPatchDouble(path)
  getPatchDouble(path, callback)
end

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

function watchPatchString(path, callback)
  refreshViewMap[path] = callback
  _WatchPatchString(path)
  getPatchString(path, callback)
end

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

function watchPatchJSON(path, callback)
  refreshViewMap[path] = callback
  _WatchPatchJSON(path)
  getPatchJSON(path, callback)
end
