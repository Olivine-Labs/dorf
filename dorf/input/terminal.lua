local stringx = require 'pl.stringx'

local function parse(command)
  if command == 'exit' then return command end
  local command, data = command:split(' ', 2)
  local success, command, data = require('input.terminal.' .. command)(data)

  if success then
    return command, data
  end

  return nil
end

return function(msg)
  local command

  repeat
    command = io.read()
    print(command)

    if command then
      local command, data = parse(command)
      if command then
        msg.send(command, data)
      end
    end
  until command == 'exit' or command == 'quit'

  msg.send('exit')
end
