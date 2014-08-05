local stringx = require 'pl.stringx'

local function parse(command)
  local command, data = stringx.split(command, ' ', 2)

  local success, command, data = pcall(function()
    return require('input.terminal.' .. command)(data)
  end)

  if success then
    return command, data
  end

  return nil
end

return function(msg)
  local command, data

  repeat
    command = io.read()
    if command then print(command) end

    if command and command ~= 'exit' then
      command, data = parse(command)

      if command then
        msg.send(command, data)
      end
    end
  until command == 'exit'

  msg.send('exit')
end
