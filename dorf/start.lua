local lanes = require 'lanes'.configure()
local l = lanes.linda()
local config = require 'config'
local m = lanes.require 'message'
local uuid = require 'uuid'

local inputs, outputs = {}, {}

for _, v in pairs(config.inputs) do
  local message = m(l, 'game')
  inputs[uuid.new()] = lanes.gen('*', function()
    local ok, err = pcall(function() require(v)(message) end)
    if not ok then print(err) end
  end)()
end

for _, v in pairs(config.outputs) do
  local id = uuid.new()
  outputs[id] = lanes.gen('*', function()
    local ok, err = pcall(function()
      local message = m(l, id)
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
  outputMessage[#outputMessage+1] = m(l, k)
end

lanes.gen('*', function()
  local ok, err = pcall(function()
    local message = m(l, 'output')
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
    local message = m(l, 'game')
    local output = m(l, 'output')
    local cmd, data
    repeat
      cmd, data = message.receive()
      data.speed = 10
      output.send(cmd, data)
    until not cmd
  end)
  if not ok then print(err) end
end)()

l:receive('exit')
