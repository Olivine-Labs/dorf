local stringx = 'pl.stringx'

-- "10 1,2"
return function(data)
  local id, coords = stringx.split(data, ' ', 2)
  local x,y = stringx.split(coords, ',', 2)
  return 'move', { id = id, x = x, y = y }
end
