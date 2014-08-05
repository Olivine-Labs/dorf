local ll = require 'lanes'.configure()
local linda = ll.linda()
local Channel = require 'channel'(linda)
local uuid = require 'uuid'

local s = { Channel = Channel }
local channels = {}
local lanes = {}

channels['exit'] = Channel('exit')

function s.add(fn)
  local id = uuid.new()
  local channel = Channel(id)
  local lane = ll.gen('*', function()
    local trace
    local ok, err = xpcall(
    function()
      return fn(channel)
    end,
    function(msg)
      trace = debug.traceback()
      return msg
    end)
    if not ok then print((err and err..'\n' or '')..(trace and trace or '')) end
    return err
  end)()
  lanes[id] = lane
  channels[id] = channel
  return id, channel
end

function s.get(id)
  return channels[id]
end

function s.kill(id, timeout)
  channels[id] = nil
  if lanes[id] then
    lanes[id]:cancel(timeout)
  end
end

function s.killAll(timeout)
  for id in pairs(channels) do
    s.kill(id, timeout)
  end
end

function s.waitForExit()
  channels['exit'].receive()
end

return s
