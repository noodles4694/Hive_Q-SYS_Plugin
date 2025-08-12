rapidjson = require("rapidjson")

ws = WebSocket.New()
local wsConnected = false
local sequenceNo = 0
local pendingCallbacks = {}

function testSocket()
  print("Testing WebSocket connection...")
  connectSocket("192.168.1.30")
end

-- WebSocket event handlers
ws.Connected = function()
  wsConnected = true
  print("WebSocket connection established")
  getPatchDouble("/LAYER 1/FILE SELECT/Value", doubleHandler)
end

ws.Closed = function()
  wsConnected = false
  print("WebSocket connection closed")
end

ws.Data = function(ws, data)
  print("Data received: ", data)
  local response = rapidjson.decode(data)
  print("Sequence: " .. (response and response.sequence or "nil"))
  print("API Version: " .. (response and response.apiVersion or "nil"))
  print("Path: " .. (response and response.args.Path or "nil"))
  print("Name: " .. (response and response.name or "nil"))
  print("Value: " .. (response and response.ret.Value))
  if response and response.apiVersion == 1 and response.sequence and pendingCallbacks[response.sequence] then
    local callback = pendingCallbacks[response.sequence]
    callback(response.args.Path, response.ret.Value)
    pendingCallbacks[response.sequence] = nil
  else
    print("No callback found for sequence: " .. (response and response.sequence or "nil"))
  end
end

ws.Error = function(err)
  print("WebSocket error: " .. err)
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

function getPatchDouble(path, callback)
  if (wsConnected) then
    -- Increment the sequence number for each request
    sequenceNo = sequenceNo + 1
    if sequenceNo > 9999 then
      sequenceNo = 1 -- Reset sequence number if it exceeds 9999
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

-- Handler for double values received from the patch
function doubleHandler(path, val)
  print("Double value received for " .. path .. ": " .. val)
  -- Handle the double value received from the patch
  -- You can update controls or perform other actions here
end
