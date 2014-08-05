return function(input, output)
  local g = {}

  function g.input()
    local cmd, data = input.receive(0)
    if cmd then
      data.speed = 10
      output.send(cmd, data)
    end
  end

  function g.run()
    --TODO
  end

  return g
end
