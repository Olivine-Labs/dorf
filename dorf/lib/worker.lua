local ll = require 'lanes'
local Channel = require 'lib.channel'
local uuid = require 'uuid'

return function(id, root)
  local w = {}

  local channel = Channel(root)

  local lane = ll.gen('*', function()
    local trace

    local ok, err = xpcall(
    function()
      local ev = require 'ev'
      local loop = ev.Loop.new()
      local work = {}
      local input = ev.Idle.new(function(loop, input, revents)
        local cmd, data = channel.receive()
        if not cmd then 
          for _, v in pairs(work) do
            v.fn(unpack(v.args))
          end
        elseif cmd == 'add' then
          work[data.id] = data
        elseif cmd == 'remove' then
          work[data.id] = nil
        elseif cmd == 'destroy' then
          work = nil
          input:stop(loop)
          channel.send('destroy', true)
        end
      end)

      input:start(loop)
      loop:loop()
    end,
    function(msg)
      trace = debug.traceback()
      return msg
    end)
    if not ok then print((err and err..'\n' or '')..(trace and trace or '')) end
    return err
  end)()

  w.lane = lane
  w.channel = channel
  w.id = id

  function w.destroy()
    channel.send('destroy')
    local destroyed = channel.receive(3)
    if not destroyed then
      w.lane:cancel()
    end
  end

  function w.add(fn, args, id)
    args = args or {}
    id = id or uuid.new()
    channel.send('add', {id=id, fn=fn, args=args})
    return id
  end

  function w.remove(id)
    channel.send('remove', {id=id})
  end

  return w
end
