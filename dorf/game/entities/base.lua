local uuid = require 'uuid'

local function Base()
  local base = {
    id = uuid.new
  }

  return base
end
