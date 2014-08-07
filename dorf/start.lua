local scheduler = require 'lib.scheduler'()
local config = require 'config'

local inputs, outputs = {}, {}

local gameChannel = scheduler.channel()

local ok, err = pcall(function()
  --register output threads
  for _, v in pairs(config.outputs) do
    local worker = scheduler.new()
    local channel = scheduler.channel()
    worker.add(function(channel)
      local cmd, data = channel.receiveAndBlock()
      if cmd then require(v)(cmd, data) end
    end, {channel})
    outputs[worker.id] = channel
  end

  local outputChannel = scheduler.channelFacade(outputs)

  --register game
  local gameWorker = scheduler.new()
  gameWorker.add(function()
    local game = require 'game'(outputChannel)
    while true do
      local cmd, data = gameChannel.receiveAndBlock()
      if cmd == 'tick' then
        game.run()
      else
        game.input(cmd, data)
      end
    end
  end)

  --register input threads
  for _, v in pairs(config.inputs) do
    local worker = scheduler.new()
    worker.add(function() require(v)(gameChannel) end)
    inputs[worker.id] = channel
  end

  local socket = require 'socket'
  local exit
  repeat
    gameChannel.send('tick')
    socket.sleep(0.01)
    exit = scheduler.checkExit()
  until exit
end)

if err then print(err) end

scheduler.destroyAll()

os.exit(0)
