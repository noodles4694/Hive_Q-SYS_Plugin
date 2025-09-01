-- Description: Utility functions for runtime scripts

-- Logging functions
function fn_log_message(message)
  Log.Message(message)
  print(message)
end
function fn_log_error(message)
  if Properties["Logging Level"].Value == "Errors Only" or Properties["Logging Level"].Value == "Debug" then
    Log.Error(message)
    print("Error: " .. message)
  end
end
function fn_log_debug(message)
  if Properties["Logging Level"].Value == "Debug" then
    Log.Message("Debug: " .. message)
    print("Debug: " .. message)
  end
end

---checks if a string represents an ip address
function fn_check_valid_ip(ip)
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
function fn_compare_ips(ip1, ip2)
  local function normalize(ip)
    local parts = {}
    if not ip then
      return ""
    end
    for octet in string.gmatch(ip, "%d+") do
      table.insert(parts, tostring(tonumber(octet))) -- remove leading zeros
    end
    return table.concat(parts, ".")
  end
  return normalize(ip1) == normalize(ip2)
end
