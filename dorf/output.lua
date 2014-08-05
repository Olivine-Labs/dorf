local mediator = require('mediator')()

-- load commands
require('commands.move')(mediator)

return function(command, data)
  mediator.publish({ command }, data)
end
