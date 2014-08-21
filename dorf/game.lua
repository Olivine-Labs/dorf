local World = require 'game.entities.world'

return function(scheduler, output)
  local g = {}

  local world = World({
    dim = {
      x = 5,
      y = 5,
      z = 5
    }
  })
  scheduler.workers(8)

  local function move(entity, x, y, z)

    if world:getTileWeight(x,y,z) < 1 then
      entity.x, entity.y, entity.z = x, y, z
      return true
    end

    return false
  end

  function g.input(cmd, data)
    if cmd then
      local entity = world.entities[data.id]
      local x, y, z =
      data.x and data.x + entity.x or entity.x,
      data.y and data.y + entity.y or entity.y,
      data.z and data.z + entity.z or entity.z

      move(entity, x, y, z)

      data.speed = entity.speed
      data.x = entity.x
      data.y = entity.y
      data.z = entity.z
      output.send(cmd, data)
    end
  end

  function g.run()
  end

  return g
end
