local function testItRequiresPosition(motion, entity, position)  
  assert(pcall(function() motion.add(entity) end) == false, "It should require Position")
  position.add(entity)
  motion.add(entity)
end

local function testItCanBeRemoved(motion, entity, position)
  position.add(entity)
  motion.add(entity)
  motion.remove(entity)    
  assert(motion.has(entity) == false, "Should have been removed")
end

local function testItBlocksRemovingPosition(motion, entity, position)
  position.add(entity)
  motion.add(entity)
  assert(pcall(function() position.remove(entity) end) == false, "It should block removing Position")
end

local function testItCanBeAssignedMotion(motion, entity, position)
  position.add(entity)
  motion.add(entity)
  motion.get(entity):setMotion(5,10)
  local x, y = motion.get(entity):getMotion()
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
end

local function testItCanBeModified(motion, entity, position)
  position.add(entity)
  motion.add(entity)
  motion.get(entity):setMotion(5,10)
  motion.get(entity):addMotion(3,4)
  local x, y = motion.get(entity):getMotion()
  assert(x == 8, "X should be 8")
  assert(y == 14, "Y should be 14") 
end

return function()
  local p = require "classes/components/movement/position"()
  local m = require "classes/components/movement/motion"(p)
  local e = require "classes/core/newentity"
  
  testItRequiresPosition(m, e(), p)
  testItCanBeRemoved(m, e(), p)
  testItCanBeAssignedMotion(m, e(), p)
  testItBlocksRemovingPosition(m, e(), p)
  
end