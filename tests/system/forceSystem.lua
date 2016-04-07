local function testItActsOnlyOnEntitiesWithForce(forceS, eFac, force, motion)
  local e1 = eFac()
  local e2 = eFac()  
  motion.add(e2)
  force.add(e2, "someForce")
  
  force.get(e2):setForce("someForce", 3,1)
  motion.get(e2):setMotion(8,4)
  
  local entities = { e1, e2 }

  forceS:update(entities, 1)
  
  local mX, mY = motion.get(e2):getMotion()
  assert(mX == 11, "mX should be 11")
  assert(mY == 5, "mY should be 5")
  
end

local function testItMovesBasedOnDT(forceS, eFac, force, motion)
  local e2 = eFac()  
  motion.add(e2)
  force.add(e2, "someForce")
  
  force.get(e2):setForce("someForce", 3,1)
  motion.get(e2):setMotion(8,4)
  
  local entities = { e2 }

  forceS:update(entities, 0.5)
  
  local mX, mY = motion.get(e2):getMotion()
  assert(mX == 9.5, "mX should be 9.5")
  assert(mY == 4.5, "mY should be 4.5")
  
end


return function()
  local position = require "classes/components/collision/position"()
  local motion = require "classes/components/movement/motion"(position)
  local force = require "classes/components/movement/force"(motion)
  
  local system = require "classes/system/forceSystem"(force, motion)
  local e = require "classes/core/newentity"
  
  local eFac = function()
    local ent = e()
    position.add(ent)
    return ent
  end

  testItActsOnlyOnEntitiesWithForce(system, eFac, force, motion)
  testItMovesBasedOnDT(system, eFac, force, motion)
end