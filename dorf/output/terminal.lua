function move(msg, data)
  return data.id .. " moving to " .. data.x .. "," .. data.y .. " at speed " .. data.speed
end

function exit(msg, data)
  msg.send('exit')
end

local map = {
  move = move,
  exit = exit,
}

return function(msg, command, data)
  io.write(map[command](msg, data))
  io.flush()
end
