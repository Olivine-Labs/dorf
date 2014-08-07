local ll = require 'lanes'.configure({nb_keepers=8})

return function()
  local Worker = require 'lib.worker'
  local Channel = require 'lib.channel'
  local uuid = require 'uuid'
  local workers = {}
  local work = {}
  local root = Channel()

  local s = {}

  local function new(id)
    id = id or uuid.new()
    local worker = Worker(id, root)
    workers[id] = worker
    return worker
  end

  function s.add(fn, args, estimate)
    if not estimate then estimate = 1 end
    local worker
    for _, v in pairs(workers) do
      if v.load + estimate <= 100 and (not worker or v.load < worker.load) then
        worker = v
      end
    end
    if not worker then
      worker = new()
      --add very short sleep to keep cpu usage down
      worker.add(function()
        local socket = require 'socket'
        socket.sleep(0.001)
      end)
    end
    local id = uuid.new()
    work[id] = {
      fn = fn,
      load = estimate,
      worker = worker
    }
    worker.add(fn, args, id)
    worker.load = worker.load + estimate
    return id
  end

  function s.remove(id)
    work[id].worker.remove(id)
    work[id].worker.load = work[id].worker.load - work[id].load
    work[id] = nil
  end

  function s.workers(num)
    if not num then num = 8 end
    for i=1, num do
      new()
    end
  end

  function s.get(id)
    return workers[id].worker
  end

  local function destroy(id)
    workers[id].destroy()
    workers[id] = nil
  end

  function s.destroy()
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
