local function testItRequiresPosition(force, entity, position)  
  assert(pcall(function() force.add(entity, "someMotion") end) == false, "It should require Position")
  position.add(entity)
  force.add(entity, "someMotion")
end

local function testItCanBeRemoved(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")
  force.remove(entity)    
  assert(force.has(entity) == false, "Should have been removed")
end

local function testItBlocksRemovingPosition(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")
  assert(pcall(function() position.remove(entity) end) == false, "It should block removing Position")
end

local function testItCanBeAssignedMotion(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")
  force.get(entity):setMotion("someMotion", 5,10)
  local x, y = force.get(entity):getMotion("someMotion")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
end

local function testItCanBeAssignedMultipleMotions(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")
  force.add(entity, "someOtherMotion")
  force.get(entity):setMotion("someMotion", 5,10)
  force.get(entity):setMotion("someOtherMotion", 3,6)
  local x, y = force.get(entity):getMotion("someMotion")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
  local x, y = force.get(entity):getMotion("someOtherMotion")
  assert(x == 3, "X should be 3")
  assert(y == 6, "Y should be 6")
end

local function testYouCanGetSumOfMotion(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")
  force.add(entity, "someOtherMotion")
  force.get(entity):setMotion("someMotion", 5,10)
  force.get(entity):setMotion("someOtherMotion", 3,6)
  local x, y = force.get(entity):getSumMotion()
  assert(x == 8, "X should be 8")
  assert(y == 16, "Y should be 16")
end

local function testYouCanRemoveAMotionByName(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")
  force.add(entity, "someOtherMotion")
  force.get(entity):removeByName("someMotion")
  assert(pcall(function() force.get(entity):getMotion("someMotion") end) == false, "Should no longer be able to get this")
end

local function testCallingUpdateShouldChangePosition(force, entity, position)
  position.add(entity)
  force.add(entity, "someMotion")  
  force.get(entity):setMotion("someMotion", 5, 8)
  position.get(entity):setPosition(0,0)
  force.get(entity):update(1)
  local x, y = position.get(entity):getPosition()
  assert(x == 5, "X should be 5")
  assert(y == 8, "Y should be 8")
end

return function()
  local p = require "classes/components/movement/position"()
  local m = require "classes/components/movement/force"(p)
  local e = require "classes/core/newentity"
  
  testItRequiresPosition(m, e(), p)
  testItCanBeRemoved(m, e(), p)
  testItCanBeAssignedMotion(m, e(), p)
  testItBlocksRemovingPosition(m, e(), p)
  testItCanBeAssignedMultipleMotions(m, e(), p)
  testYouCanGetSumOfMotion(m, e(), p)
  testYouCanRemoveAMotionByName(m, e(), p)
  testCallingUpdateShouldChangePosition(m, e(), p)
end