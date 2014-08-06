--[[
This is a ridiculous thing...

I needed an easy shared and concurrent table for reading world data effectively...
So I made a massively concurrent, granular, data structure with a table interface.
It puts lindas in lindas in place of tables. Locks are at the key level, so only
the particular piece of data that is being written is locked. Locking larger parts
of the structure is not yet implemented, so the only atomic operations are at the
single key level.

TODO:: Implement locking arbitrary parts of the shared table
]]
local ll = require 'lanes'

local share

local meta = {
  type = 'linda',
  __index = function(self, key)
    return self.__linda:get(key)
  end,
  __newindex = function(self, key, value)
    if type(value) == 'table' then
      local mt = getmetatable(tbl)
      if not mt or mt.type ~= 'linda' then
        local new = share()
        for k, v in pairs(value) do
          new[k] = v
        end
        value = new
      end
    end
    self.__linda:set(key, value)
  end,
  __len = function(self)
    local count, n = self.__linda:count()
    for k in pairs(count) do
      if type(k) == "number" then
        n = n + 1
      end
    end
    return n
  end
}

share = function()
  return setmetatable({__linda = ll.linda()}, meta)
end

return share
