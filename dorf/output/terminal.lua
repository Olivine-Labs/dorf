function move(data)
  return data.id .. " moving to " .. data.x .. "," .. data.y .. " at speed " .. data.speed
end

local map = {
  move = move,
}

return function(command, data)
  io.write(map[command](data))
  io.flush()
end
