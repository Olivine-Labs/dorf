return function(l, channel)
  local m = {}

  function m.send(cmd, data)
    if cmd == 'exit' then
      l:send(cmd, data)
    else
      l:send(channel, {cmd, data})
    end
  end

  function m.receive(cmd)
    local key, value = l:receive(channel)
    return value
  end

  return m
end
