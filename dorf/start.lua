local scheduler = require 'scheduler'
local config = require 'config'
local inputs, outputs = {}, {}

--register output threads
for _, v in pairs(config.outputs) do
  local id, channel = scheduler.add(function(channel)
    local cmd, data
    repeat
      cmd, data = channel.receive()
      require(v)(cmd, data)
    until not cmd
  end)
  outputs[id] = channel
end

--register output firehose
local outputId, outputChannel = scheduler.add(function(channel)
  local cmd, data
  repeat
    cmd, data = channel.receive()
    for _, v in pairs(outputs) do
      v.send(cmd, data)
    end
  until not cmd
end)

--register game
local gameId, gameChannel = scheduler.add(function(channel)
  local ev = require 'ev'
  local loop = ev.Loop.default

  local game = require 'game'(channel, outputChannel)
  local run = ev.Idle.new(game.run)
  run:start(loop)

  set_finalizer(function()
    loop:unloop()
    run:stop(loop)
  end)

  loop:loop()
end)

--register input threads
for _, v in pairs(config.inputs) do
  local id, channel = scheduler.add(function(channel) require(v)(gameChannel) end)
  inputs[id] = channel
end

scheduler.waitForExit()

scheduler.killAll()

os.exit(0)
