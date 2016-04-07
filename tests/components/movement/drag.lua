local function testItRequiresAnAmount(drag, entity, force)    
  force.add(entity)
  assert(pcall(function() drag.add(entity) end) == false, "It should require an amount")
  drag.add(entity, 5)
end

local function testItRequiresForce(drag, entity, force)  
  assert(pcall(function() drag.add(entity) end) == false, "It should require Force")
  force.add(entity)
  drag.add(entity, 5)
end

local function testItCanBeRemoved(drag, entity, force)
  force.add(entity)
  drag.add(entity, 5)
  drag.remove(entity)    
  assert(drag.has(entity) == false, "Should have been removed")
end

local function testItBlocksRemovingForce(drag, entity, force)
  force.add(entity)
  drag.add(entity, 5)
  assert(pcall(function() force.remove(entity) end) == false, "It should block removing Force")
end

local function testItCanBeAssignedDrag(drag, entity, force)
  force.add(entity)
  drag.add(entity, 2)
  drag.get(entity):setDragAmount(5)
  local amount = drag.get(entity):getDragAmount()
  assert(amount == 5, "Drag should be 5")
end

local function testItCanBeModified(drag, entity, force)
  force.add(entity)
  drag.add(entity, 5)  
  drag.get(entity):addDragAmount(3)
  local amount = drag.get(entity):getDragAmount()
  assert(amount == 8, "Drag should be 8")  
end

return function()
  local p = require "classes/components/collision/position"()
  local m = require "classes/components/movement/motion"(p)
  local f = require "classes/components/movement/force"(m)
  local d = require "classes/components/movement/drag"(f)
  local e = require "classes/core/newentity"
  
  function makeEnt()
    local ent = e()
    p.add(ent)
    m.add(ent)
    return ent
  end
  
  testItRequiresAnAmount(d, makeEnt(), f)
  testItRequiresForce(d, makeEnt(), f)
  testItCanBeRemoved(d, makeEnt(), f)
  testItBlocksRemovingForce(d, makeEnt(), f)
  testItCanBeAssignedDrag(d, makeEnt(), f)
  testItCanBeModified(d, makeEnt(), f)
  
end