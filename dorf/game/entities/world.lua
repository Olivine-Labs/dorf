local Base = require 'game.entities.base'

local function buildMap(x,y,z)
  local currentX, currentY, currentZ = 1, 1, 1
  local map = { }

  while currentZ <= z do
    map[currentZ] = {}

    currentY = 1

    while currentY <= y do
      map[currentZ][currentY] = {}

      currentX = 1

      while currentX <= x do
        if currentY == 1 or currentY == y or
            currentX == 1 or currentX == x then
          map[currentZ][currentY][currentX] = 1
        else
          map[currentZ][currentY][currentX] = 0
        end
        currentX = currentX + 1
      end

      currentY = currentY + 1
    end

    currentZ = currentZ + 1
  end

  return map
end

local function getTileWeight(self, x, y, z)
  -- check bounds

  if x > self.dim.x or y > self.dim.y or z > self.dim.z
     or x < 1 or y < 1 or z < 0 then

    return 1
  end

  return 0
end

local function World(parameters)
  local world = Base()

  world.dim = {
    x = parameters.dim.x or 5,
    y = parameters.dim.y or 5,
    z = parameters.dim.z or 1,
  }

  world.name = 'World of Enlightenment'

  world.map = buildMap(world.dim.x, world.dim.y, world.dim.z)

  world.entities = {}

  world.entities['1'] = {
    speed = 10,
    x=2,
    y=2,
    z=1
  }

  world.getTileWeight = getTileWeight

  return world
end

return World
