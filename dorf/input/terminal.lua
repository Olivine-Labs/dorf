local stringx = require 'pl.stringx'

function parse(command)
  local command, data = command:split(' ', 2)
  local success, command, data = require('input.terminal.' .. command)(data)

  if success then
    return command, data
  end

  return nil
end

return function terminalInput(msg)
  local command
  repeat
    command = io.read()

    if command then
      command, data = parse(command)

      if command then
        msg.send(command, data)
      end
    end
  until command == 'quit'
end
