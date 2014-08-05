local function World(parameters)
  local world = require 'game.entities.base'

  world.dim = {
    x = parameters.dim.x,
    y = parameters.dim.y,
    z = parameters.dim.z,
    name = 'World of Enlightenment'
  }

  return world
end

return World
