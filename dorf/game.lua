local share = require 'lib.share'
return function(input, output)
  local g = {}
  local world = share()

  world.entities = {}
  world.entities['1'] = {
    speed = 10,
    x=1,
    y=1,
    z=1
  }
  function g.input()
    local cmd, data = input.receive(0)
    if cmd then
      print(data.id)
      local entity = world.entities[data.id]
      if data.x then
        entity.x = entity.x+data.x
      end
      if data.y then
        entity.y = entity.y+data.y
      end
      if data.z then
        entity.z = entity.z+data.z
      end
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
