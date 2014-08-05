return function(l, channel)
  local m = {}

  function m.send(cmd, data)
    if cmd == 'exit' then
      l:send(cmd, data)
    else
      l:send(channel, {cmd, data})
    end
    print('sent: '..cmd..' to '..channel)
  end

  function m.receive()
    print('attempting to receive on '..channel)
    local key, value = l:receive(channel)
    print('received:'..value[1]..' from '..channel)
    return value[1], value[2]
  end

  return m
end
