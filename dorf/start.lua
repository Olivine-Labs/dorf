local lanes = require 'lanes'.configure()
local l = lanes.linda()
local config = require 'config'

local inputs, outputs = {}, {}
for _, v in pairs(config.inputs) do
  local message = require 'message'(l, 'game')
  local input = lanes.require(v)
  inputs[#inputs+1] = lanes.gen('*', function()
    input()
  end)
end

for _, v in pairs(config.outputs) do
  local output = lanes.require(v)
  outputs[#outputs+1] = lanes.gen('*', function()
    local msg = true
    local message = require 'message'(l, 'output')
    repeat
      msg = message.receive()
      if msg then
        output(message, msg.cmd, msg.data)
      end
    until not msg
  end)()
end

local game = lanes.gen('*', function()
  --TODO
end)

l:receive('exit')
