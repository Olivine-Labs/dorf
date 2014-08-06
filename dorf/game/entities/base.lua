local share = require 'lib.share'
local uuid = require 'uuid'

local function Base()
  local base = share()

  base.id= uuid.new

  return base
end

return Base
