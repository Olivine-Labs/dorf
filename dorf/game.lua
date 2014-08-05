return function(output, cmd, data)
  data.speed = 10
  output.send(cmd, data)
end
