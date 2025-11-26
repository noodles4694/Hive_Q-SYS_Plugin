-- Description: Utility functions for runtime scripts

-- Logging functions

-- Logs a message to both the Log and the console
function FnLogMessage(message)
  Log.Message(message)
  print(message)
end
-- Logs an error message to both the Log and the console, but only if logging level is set to Errors Only or Debug
function FnLogError(message)
  if Properties["Logging Level"].Value == "Errors Only" or Properties["Logging Level"].Value == "Debug" then
    Log.Error(message)
    print("Error: " .. message)
  end
end
-- Logs a warning message to both the Log and the console, but only if logging level is set to Debug
function FnLogWarning(message)
  if Properties["Logging Level"].Value == "Debug" then
    Log.Message("Warning: " .. message)
    print("Warning: " .. message)
  end
end
-- Logs a debug message to both the Log and the console, but only if logging level is set to Debug
function FnLogDebug(message)
  if Properties["Logging Level"].Value == "Debug" then
    Log.Message("Debug: " .. message)
    print("Debug: " .. message)
  end
end

function SetOnline()
  if Controls.Status.Value ~= StatusState.OK then
    Controls.Status.Value = StatusState.OK
  end
  if Controls.Status.String ~= "Online" then
    Controls.Status.String = "Online"
  end
end

function SetInitializing(msg)
  if Controls.Status.Value ~= StatusState.INITIALIZING then
    Controls.Status.Value = StatusState.INITIALIZING
  end
  if Controls.Status.String ~= (msg or "Initializing") then
    Controls.Status.String = msg or "Initializing"
  end
end

function SetFault(msg)
  if Controls.Status.Value ~= StatusState.FAULT then
    Controls.Status.Value = StatusState.FAULT
  end
  if Controls.Status.String ~= (msg or "Fault") then
    Controls.Status.String = msg or "Fault"
  end
end

function SetCompromised(msg)
  if Controls.Status.Value ~= StatusState.COMPROMISED then
    Controls.Status.Value = StatusState.COMPROMISED
  end
  if Controls.Status.String ~= (msg or "Compromised") then
    Controls.Status.String = msg or "Compromised"
  end
end

function SetMissing(msg)
  if Controls.Status.Value ~= StatusState.MISSING then
    Controls.Status.Value = StatusState.MISSING
  end
  if Controls.Status.String ~= (msg or "Missing") then
    Controls.Status.String = msg or "Missing"
  end
end

function SetNotPresent(msg)
  if Controls.Status.Value ~= StatusState.NOTPRESENT then
    Controls.Status.Value = StatusState.NOTPRESENT
  end
  if Controls.Status.String ~= (msg or "Not Present") then
    Controls.Status.String = msg or "Not Present"
  end
end

---checks if a string represents an ip address
function FnCheckValidIp(ip)
  if not ip then
    return false
  end
  local a, b, c, d = ip:match("^(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)$")
  a = tonumber(a)
  b = tonumber(b)
  c = tonumber(c)
  d = tonumber(d)
  if not a or not b or not c or not d then
    return false
  end
  if a < 0 or 255 < a then
    return false
  end
  if b < 0 or 255 < b then
    return false
  end
  if c < 0 or 255 < c then
    return false
  end
  if d < 0 or 255 < d then
    return false
  end
  return true
end

-- compares two ip addresses, ignoring leading zeros
function FnCompareIps(ip1, ip2)
  local function Normalize(ip)
    local parts = {}
    if not ip then
      return ""
    end
    for octet in string.gmatch(ip, "%d+") do
      table.insert(parts, tostring(tonumber(octet))) -- remove leading zeros
    end
    return table.concat(parts, ".")
  end
  return Normalize(ip1) == Normalize(ip2)
end

--- Send Wake-on-LAN magic packet to a given MAC address.
-- @param mac           string  MAC like "AA:BB:CC:DD:EE:FF" or "AABBCCDDEEFF"
-- @return boolean|string       true on success, or nil + error message
function WakeOnLan(mac)
  local broadcast_ip = "255.255.255.255"
  local port = 9

  -- Strip separators like ":" or "-" etc.
  local hex = mac:gsub("[^0-9A-Fa-f]", "")
  if #hex ~= 12 then
    return nil, "Invalid MAC address format"
  end

  -- Convert MAC string to 6 raw bytes
  local mac_bytes = {}
  for i = 1, 12, 2 do
    local byte = tonumber(hex:sub(i, i + 1), 16)
    if not byte then
      return nil, "Invalid MAC address hex"
    end
    mac_bytes[#mac_bytes + 1] = string.char(byte)
  end
  local mac_raw = table.concat(mac_bytes)

  -- Build magic packet: 6 x 0xFF followed by MAC repeated 16 times
  local magic_packet = string.rep(string.char(0xFF), 6) .. string.rep(mac_raw, 16)

  local udp = UdpSocket.New()

  -- Send via UDP broadcast
  if not udp then
    return nil, "Failed to create UDP socket: " .. tostring(err)
  end
  udp:Open()
  udp:Send(broadcast_ip, port, magic_packet)

  -- close the port after 500ms
  Timer.CallAfter(
    function()
      udp:Close()
    end,
    0.5
  )

  return true
end
