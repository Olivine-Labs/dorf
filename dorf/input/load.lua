return function(msg)
  local command, data
  local x, y = 1, 1
  repeat
    msg.send('move', {id='1',x=x,y=y })
    x = x * -1
    y = y * -1
  until false

  msg.send('exit')
end
