local share = require 'lib.share'
return function(input, output)
  local g = {}
  local world = share()

  function g.input()
    local cmd, data = input.receive(0)
    if cmd then
      data.speed = 10
      output.send(cmd, data)
    end
  end

  function g.run()
    g.input()
  end

  return g
end
