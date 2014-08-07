local ll = require 'lanes'.configure({nb_keepers=8})

return function()
  local Worker = require 'lib.worker'
  local Channel = require 'lib.channel'
  local uuid = require 'uuid'
  local workers = {}

  local root = Channel()

  local s = {}

  function s.new(o, id)
    id = id or uuid.new()
    local worker = Worker(id, root)
    workers[id] = worker
    return worker
  end

  function s.get(id)
    return workers[id].worker
  end

  function s.destroy(id)
    workers[id].destroy()
    workers[id] = nil
  end

  function s.destroyAll()
    for _, v in pairs(workers) do
      v.destroy()
    end
  end

  function s.checkExit()
    return root.receive()
  end

  function s.channel()
    return Channel(root)
  end

  function s.channelFacade(channels)
    local c = {}
    c.send = function(cmd, data)
      for _, v in pairs(channels) do
        v.send(cmd, data)
      end
    end
    return c
  end

  return s
end
