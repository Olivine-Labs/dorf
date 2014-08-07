local Scheduler = require 'lib.scheduler'
local scheduler = Scheduler()
local config = require 'config'

local inputs, outputs = {}, {}

local gameChannel = scheduler.channel()

local ok, err = pcall(function()
  --register output threads
  for _, v in pairs(config.outputs) do
    local channel = scheduler.channel()
    scheduler.add(function(channel)
      local cmd, data = channel.receiveAndBlock()
      if cmd then require(v)(cmd, data) end
    end, {channel}, 100)
    outputs[#outputs+1] = channel
  end

  local outputChannel = scheduler.channelFacade(outputs)

  --register game
  scheduler.add(function()
    local s = Scheduler()
    local game = require 'game'(s, outputChannel)
    while true do
      local cmd, data = gameChannel.receiveAndBlock()
      if cmd == 'tick' then
        game.run()
      else
        game.input(cmd, data)
      end
    end
  end, {}, 100)

  --register input threads
  for _, v in pairs(config.inputs) do
    scheduler.add(function() require(v)(gameChannel) end, {}, 100)
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

scheduler.destroy()

os.exit(err and 1 or 0)
