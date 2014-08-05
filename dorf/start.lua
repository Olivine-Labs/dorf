local lanes = require 'lanes'.configure()
local linda = lanes.linda()
local config = require 'config'
local Game = require 'game'
local Message = lanes.require 'message'
local uuid = require 'uuid'

local inputs, outputs = {}, {}

for _, v in pairs(config.inputs) do
  local message = Message(linda, 'game')
  local id = uuid.new()
  inputs[id] = lanes.gen('*', function()
    local ok, err = pcall(function() require(v)(message) end)
    if not ok then print(err) end
  end)()
end

for _, v in pairs(config.outputs) do
  local id = uuid.new()
  outputs[id] = lanes.gen('*', function()
    local ok, err = pcall(function()
      local message = Message(linda, id)
      local cmd, data
      repeat
        cmd, data = message.receive()
        local ok, err = pcall(function() require(v)(cmd, data) end)
        if not ok then print(err) end
      until not cmd
    end)
    if not ok then print(err) end
  end)()
end

local outputMessage = {}

for k, v in pairs(outputs) do
  outputMessage[#outputMessage+1] = Message(linda, k)
end

lanes.gen('*', function()
  local ok, err = pcall(function()
    local message = Message(linda, 'output')
    local cmd, data
    repeat
      cmd, data = message.receive()
      for _, v in pairs(outputMessage) do
        v.send(cmd, data)
      end
    until not cmd
  end)
  if not ok then print(err) end
end)()

local game = lanes.gen('*', function()
  local ok, err = pcall(function()
    local ev = require 'ev'
    local loop = ev.Loop.default

    local game = Game(Message(linda, 'game'), Message(linda, 'output'))
    local input = ev.Idle.new(game.input)
    local run = ev.Idle.new(game.run)
    input:start(loop)
    run:start(loop)
    loop:loop()
  end)
  if not ok then print(err) end
end)()

linda:receive('exit')
os.exit(0)
