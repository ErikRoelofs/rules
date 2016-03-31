local function testItRequiresPosition(force, entity, position)  
  assert(pcall(function() force.add(entity, "someForce") end) == false, "It should require Position")
  position.add(entity)
  force.add(entity, "someForce")
end

local function testItCanBeRemoved(force, entity, position)
  position.add(entity)
  force.add(entity, "someForce")
  force.remove(entity)    
  assert(force.has(entity) == false, "Should have been removed")
end

local function testItBlocksRemovingPosition(force, entity, position)
  position.add(entity)
  force.add(entity, "someForce")
  assert(pcall(function() position.remove(entity) end) == false, "It should block removing Position")
end

local function testItCanBeAssignedForce(force, entity, position)
  position.add(entity)
  force.add(entity, "someForce")
  force.get(entity):setForce("someForce", 5,10)
  local x, y = force.get(entity):getForce("someForce")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
end

local function testItCanBeAssignedMultipleForces(force, entity, position)
  position.add(entity)
  force.add(entity, "someForce")
  force.add(entity, "someOtherForce")
  force.get(entity):setForce("someForce", 5,10)
  force.get(entity):setForce("someOtherForce", 3,6)
  local x, y = force.get(entity):getForce("someForce")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
  local x, y = force.get(entity):getForce("someOtherForce")
  assert(x == 3, "X should be 3")
  assert(y == 6, "Y should be 6")
end

local function testYouCanGetSumOfForce(force, entity, position)
  position.add(entity)
  force.add(entity, "someForce")
  force.add(entity, "someOtherForce")
  force.get(entity):setForce("someForce", 5,10)
  force.get(entity):setForce("someOtherForce", 3,6)
  local x, y = force.get(entity):getSumForce()
  assert(x == 8, "X should be 8")
  assert(y == 16, "Y should be 16")
end

local function testYouCanRemoveAForceByName(force, entity, position)
  position.add(entity)
  force.add(entity, "someForce")
  force.add(entity, "someOtherForce")
  force.get(entity):removeByName("someForce")
  assert(pcall(function() force.get(entity):getForce("someForce") end) == false, "Should no longer be able to get this")
end

return function()
  local p = require "classes/components/movement/position"()
  local m = require "classes/components/movement/force"(p)
  local e = require "classes/core/newentity"
  
  testItRequiresPosition(m, e(), p)
  testItCanBeRemoved(m, e(), p)
  testItCanBeAssignedForce(m, e(), p)
  testItBlocksRemovingPosition(m, e(), p)
  testItCanBeAssignedMultipleForces(m, e(), p)
  testYouCanGetSumOfForce(m, e(), p)
  testYouCanRemoveAForceByName(m, e(), p)  
end