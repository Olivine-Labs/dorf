return function(linda)
  return function(name, lane)
    local m = {}

    function m.send(cmd, data)
      if cmd == 'exit' then
        linda:send(cmd, data)
      else
        linda:send(name, {cmd, data})
      end
    end

    function m.receive(timeout)
      local key, value = linda:receive(timeout, name)
      if not value then return nil end
      return value[1], value[2]
    end
    return m
  end
end
