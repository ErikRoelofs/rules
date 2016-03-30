local function testItExists(carryable, entity)
  carryable.add(entity)
  assert(carryable.has(entity) == true, "It should be there")
end

local function testItCanBeRemoved(carryable, entity)
  carryable.add(entity)
  carryable.remove(entity)    
  assert(carryable.has(entity) == false, "Should have been removed")
end

return function()
  local p = require "classes/components/carryable"()
  local e = require "classes/core/newentity"
  
  testItExists(p, e())
  testItCanBeRemoved(p, e())
  
end