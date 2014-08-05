local lanes = require 'lanes'.configure()
local linda = lanes.linda()
local config = require 'config'
local game = require 'game'
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

lanes.gen('*', function()
  local ok, err = pcall(function()
    local message = Message(linda, 'game')
    local cmd, data
    repeat
      cmd, data = message.receive()
      game(Message(linda, 'output'), cmd, data)
    until not cmd
  end)
  if not ok then print(err) end
end)()

linda:receive('exit')
