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
    local message = m(id)
    local data
    repeat
      data = message.receive()
      local ok, err = pcall(function() require(v)(data[1], data[2]) end)
      if not ok then print(err) end
    until not data
  end)()
end

local outputMessage = {}

for k, v in pairs(outputs) do
  outputMessage[#outputMessage+1] = m(k)
end

lanes.gen(function()
  local message = m(l, 'output')
  local data
  repeat
    data = message.receive()
    for _, v in pairs(outputMessage) do
      v.send(data)
    end
  until not data
end)

l:receive('exit')
