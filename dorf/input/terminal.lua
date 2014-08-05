return function terminalInput(msg)
  local command
  repeat
    command = io.read()
    if command then
      msg.send(command, data)
    end
  until command == 'quit'
end
