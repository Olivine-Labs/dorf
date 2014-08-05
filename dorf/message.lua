return function(linda, channel)
  local m = {}

  function m.send(cmd, data)
    if cmd == 'exit' then
      linda:send(cmd, data)
    else
      linda:send(channel, {cmd, data})
    end
    print('sent: '..cmd..' to '..channel)
  end

  function m.receive(timeout)
    local key, value = linda:receive(timeout, channel)
    if not value then return nil end
    return value[1], value[2]
  end

  return m
end
