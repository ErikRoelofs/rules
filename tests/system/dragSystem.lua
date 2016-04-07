local function testItActsOnlyOnEntitiesWithDrag(dragS, eFac, force, drag)
  local e1 = eFac()
  local e2 = eFac()  
  force.add(e1, "someForce")
  force.get(e1):setForce("someForce", 10,8)
  
  force.add(e2, "someForce")
  force.get(e2):setForce("someForce", 10,8)
  drag.add(e2, 5)
    
  local entities = { e1, e2 }
  dragS:update(entities, 1)
  
  assert( force.get(e1):hasForce("drag") == false, "Drag system should not work on this" )
  
  local x, y = force.get(e2):getForce("drag")
  assert(x == -5, "Drag X should be -5")
  assert(y == -5, "Drag Y should be -5")
  
end

local function testItUpdatesBasedOnDt(dragS, eFac, force, drag)
  local e1 = eFac()
  local e2 = eFac()  
  force.add(e2, "someForce")
  force.get(e2):setForce("someForce", 10,8)
  drag.add(e2, 5)
    
  local entities = { e1, e2 }
  dragS:update(entities, 0.5)
  
  local x, y = force.get(e2):getForce("drag")
  assert(x == -2.5, "Drag X should be -2.5")
  assert(y == -2.5, "Drag Y should be -2.5")
end

local function testItCannotExceedPresentForce(dragS, eFac, force, drag)
  local e1 = eFac()
  local e2 = eFac()  
  force.add(e2, "someForce")
  force.get(e2):setForce("someForce", 10,8)
  drag.add(e2, 5)
    
  local entities = { e1, e2 }
  dragS:update(entities, 10)
  
  local x, y = force.get(e2):getForce("drag")
  assert(x == -10, "Drag X should be -10")
  assert(y == -8, "Drag Y should be -8")
end

local function testItTakesDragAmountFromEntity()
  assert(false, "To implement")
end

return function()
  local position = require "classes/components/collision/position"()
  local motion = require "classes/components/movement/motion"(position)
  local force = require "classes/components/movement/force"(motion)
  local drag = require "classes/components/movement/drag"(force)
  
  local system = require "classes/system/dragSystem"(drag, force)
  local e = require "classes/core/newentity"
  
  local eFac = function()
    local ent = e()
    position.add(ent)
    motion.add(ent)
    return ent
  end

  testItActsOnlyOnEntitiesWithDrag(system, eFac, force, drag)
  testItUpdatesBasedOnDt (system, eFac, force, drag)
  testItCannotExceedPresentForce(system, eFac, force, drag)
  testItTakesDragAmountFromEntity(system, eFac, force, drag)
end