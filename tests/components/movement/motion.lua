local function testItRequiresPosition(motion, entity, position)  
  assert(pcall(function() motion.add(entity, "someMotion") end) == false, "It should require Position")
  position.add(entity)
  motion.add(entity, "someMotion")
end

local function testItCanBeRemoved(motion, entity, position)
  position.add(entity)
  motion.add(entity, "someMotion")
  motion.remove(entity)    
  assert(motion.has(entity) == false, "Should have been removed")
end

local function testItBlocksRemovingPosition(motion, entity, position)
  position.add(entity)
  motion.add(entity, "someMotion")
  assert(pcall(function() position.remove(entity) end) == false, "It should block removing Position")
end

local function testItCanBeAssignedMotion(motion, entity, position)
  position.add(entity)
  motion.add(entity, "someMotion")
  motion.get(entity):setMotion("someMotion", 5,10)
  local x, y = motion.get(entity):getMotion("someMotion")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
end

local function testItCanBeAssignedMultipleMotions(motion, entity, position)
  position.add(entity)
  motion.add(entity, "someMotion")
  motion.add(entity, "someOtherMotion")
  motion.get(entity):setMotion("someMotion", 5,10)
  motion.get(entity):setMotion("someOtherMotion", 3,6)
  local x, y = motion.get(entity):getMotion("someMotion")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
  local x, y = motion.get(entity):getMotion("someOtherMotion")
  assert(x == 3, "X should be 3")
  assert(y == 6, "Y should be 6")
end

local function testYouCanGetSumOfMotion(motion, entity, position)
  position.add(entity)
  motion.add(entity, "someMotion")
  motion.add(entity, "someOtherMotion")
  motion.get(entity):setMotion("someMotion", 5,10)
  motion.get(entity):setMotion("someOtherMotion", 3,6)
  local x, y = motion.get(entity):getSumMotion()
  assert(x == 8, "X should be 8")
  assert(y == 16, "Y should be 16")
end

local function testYouCanRemoveAMotionByName(motion, entity, position)
  position.add(entity)
  motion.add(entity, "someMotion")
  motion.add(entity, "someOtherMotion")
  motion.get(entity):removeByName("someMotion")
  assert(pcall(function() motion.get(entity):getMotion("someMotion") end) == false, "Should no longer be able to get this")
end

return function()
  local p = require "classes/components/movement/position"()
  local m = require "classes/components/movement/motion"(p)
  local e = require "classes/core/newentity"
  
  testItRequiresPosition(m, e(), p)
  testItCanBeRemoved(m, e(), p)
  testItCanBeAssignedMotion(m, e(), p)
  testItBlocksRemovingPosition(m, e(), p)
  testItCanBeAssignedMultipleMotions(m, e(), p)
  testYouCanGetSumOfMotion(m, e(), p)
  testYouCanRemoveAMotionByName(m, e(), p)  
end