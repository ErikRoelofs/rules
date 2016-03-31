local function testItActsOnlyOnEntitiesWithMotion(motion, eFac)
  local e1 = eFac()
  local e2 = eFac()
  
  local entities = { e1, e2 }
  
  motion:update( entities, dt )
  
end

return function()
  local m = require "classes/system/motionSystem"()
  local e = require "classes/core/newentity"
  
  testItActsOnlyOnEntitiesWithMotion(m, e)
  
end