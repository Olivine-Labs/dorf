local stringx = require 'pl.stringx'

return function(data)
  local id, coords = unpack(stringx.split(data, ' ', 2))
  local x,y = unpack(stringx.split(coords, ',', 2))
  return 'move', { id = id, x = x, y = y }
end
