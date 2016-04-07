local function testItActsOnlyOnEntitiesWithDrag(dragS, eFac, force, drag, motion)
  local e1 = eFac()
  local e2 = eFac()  
  force.add(e1, "someForce")
  motion.get(e1):setMotion(10,8)
  
  force.add(e2, "someForce")
  motion.get(e2):setMotion(10,8)
  drag.add(e2, 1)
    
  local entities = { e1, e2 }
  dragS:update(entities, 1)
  
  assert( force.get(e1):hasForce("drag") == false, "Drag system should not work on this" )
  
  local x, y = force.get(e2):getForce("drag")
  assert(x == -10, "Drag X should be -10")
  assert(y == -8, "Drag Y should be -8")
  
end

local function testItWorksOnNegativeMotion(dragS, eFac, force, drag, motion)
  local e1 = eFac()
  local e2 = eFac()  
  force.add(e2, "someForce")
  motion.get(e2):setMotion(-10,-8)
  drag.add(e2, 1)
    
  local entities = { e1, e2 }
  dragS:update(entities, 1)
  
  local x, y = force.get(e2):getForce("drag")
  assert(x == 10, "Drag X should be 10")
  assert(y == 8, "Drag Y should be 8")
end

local function testItTakesDragAmountFromEntity(dragS, eFac, force, drag, motion)
  local e1 = eFac()
  local e2 = eFac()  
  force.add(e1, "someForce")
  motion.get(e1):setMotion(10,8)
  
  force.add(e2, "someForce")
  motion.get(e2):setMotion(10,8)
  drag.add(e1,0.5)
  drag.add(e2, 1)
    
  local entities = { e1, e2 }
  dragS:update(entities, 1)
  
  local x, y = force.get(e1):getForce("drag")
  assert(x == -5, "Drag X should be -5")
  assert(y == -4, "Drag Y should be -4")
  
  local x, y = force.get(e2):getForce("drag")
  assert(x == -10, "Drag X should be -10")
  assert(y == -8, "Drag Y should be -8")
end

return function()
  local position = require "classes/components/collision/position"()
  local motion = require "classes/components/movement/motion"(position)
  local force = require "classes/components/movement/force"(motion)
  local drag = require "classes/components/movement/drag"(force)
  
  local system = require "classes/system/dragSystem"(drag, force, motion)
  local e = require "classes/core/newentity"
  
  local eFac = function()
    local ent = e()
    position.add(ent)
    motion.add(ent)
    return ent
  end

  testItActsOnlyOnEntitiesWithDrag(system, eFac, force, drag, motion)  
  testItWorksOnNegativeMotion(system, eFac, force, drag, motion)
  testItTakesDragAmountFromEntity(system, eFac, force, drag, motion)
end