local ll = require 'lanes'

return function(root)
  local c = {}
  local linda = ll.linda()
  linda:limit('channel', 10000)
  function c.send(cmd, data)
    if root and cmd == 'exit' then
      root.send(cmd, data)
    else
      linda:send('channel', {cmd, data})
    end
  end

  function c.receive(timeout)
    local key, value = linda:receive(timeout or 0.0001, 'channel')
    if not value or not #value == 2 then return nil end
    return value[1], value[2]
  end

  function c.receiveAndBlock(key)
    local key, value = linda:receive('channel')
    if not value or not #value == 2 then return nil end
    return value[1], value[2]
  end

  return c
end
