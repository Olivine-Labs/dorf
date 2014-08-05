return function(msg)
  local command, data

  repeat
    msg.send('move', {id=1,x=1,y=1 })
  until false

  msg.send('exit')
end
