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

  function m.receive()
    print('attempting to receive on '..channel)
    local key, value = linda:receive(channel)
    print('received:'..value[1]..' from '..channel)
    return value[1], value[2]
  end

  return m
end
