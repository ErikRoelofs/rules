local function testItActsOnlyOnEntitiesWithMotion(motionS, eFac, motion, position)
  local e1 = eFac()
  local e2 = eFac()
  position.add(e2)
  motion.add(e2)
  
  position.get(e2):setPosition(1,2)
  motion.get(e2):setMotion(5,8)
  
  local entities = { e1, e2 }
  
  motionS:update( entities, 1 )
    
  local x, y = position.get(e2):getPosition()
  assert(x == 6, "X should be 6")
  assert(y == 10, "Y should be 10")
  
end

local function testItMovesBasedOnDT(motionS, eFac, motion, position)
  local entity = eFac()
  position.add(entity)
  motion.add(entity)  
  position.get(entity):setPosition(1,2)
  motion.get(entity):setMotion(5,8)  
  local entities = { entity }
  
  motionS:update( entities, 0.5 )
    
  local x, y = position.get(entity):getPosition()
  assert(x == 3.5, "X should be 3.5")
  assert(y == 6, "Y should be 6")
  
end

return function()
  local position = require "classes/components/movement/position"()
  local motion = require "classes/components/movement/motion"(position)
  
  local m = require "classes/system/motionSystem"(motion, position)
  local e = require "classes/core/newentity"
  
  testItActsOnlyOnEntitiesWithMotion(m, e, motion, position)
  testItMovesBasedOnDT(m, e, motion, position)
end