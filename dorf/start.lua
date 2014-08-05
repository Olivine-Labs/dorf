local lanes = require 'lanes'.configure()
local l = lanes.linda()
local config = require 'config'
local m = lanes.require 'message'

local inputs, outputs = {}, {}
for _, v in pairs(config.inputs) do
  local message = m(l, 'game')
  inputs[#inputs+1] = lanes.gen('*', function()
    require(v)(message)
  end)()
end

l:receive('exit')
