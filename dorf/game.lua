local share = require 'lib.share'
return function(input, output)
  local g = {}
  local world = share()

  world.entities = {}
  world.map = {
    {
      {1,1,1,1,1,},
      {1,0,0,0,1,},
      {1,0,0,0,1,},
      {1,0,0,0,1,},
      {1,1,1,1,1,},
    }
  }
  world.entities['1'] = {
    speed = 10,
    x=2,
    y=2,
    z=1
  }
  local function move(entity, x, y, z)
    if world.map[z] and world.map[z][y] and world.map[z][y][x] == 0 then
      entity.x, entity.y, entity.z = x, y, z
      return true
    end
    return false
  end

  function g.input()
    local cmd, data = input.receive(0)
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
    g.input()
  end

  return g
end
