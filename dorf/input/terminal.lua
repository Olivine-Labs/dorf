local stringx = require 'pl.stringx'

function parse(command)
  local command, data = command:split(' ', 2)
  local success, command, data = require('input.terminal.' .. command)(data)

  print(command)
  print(data)
  if success then
    return command, data
  end

  return nil
end

return function(msg)
  local command
  repeat
    command = io.read()

    if command then
      command, data = parse(command)

      if command then
        msg.send(command, data)
      end
    end
  until command == 'exit' or command == 'quit'

  msg.send('exit')
end
