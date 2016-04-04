local function testItRequiresMotion(force, entity, motion)  
  assert(pcall(function() force.add(entity, "someForce") end) == false, "It should require Motion")
  motion.add(entity)
  force.add(entity, "someForce")
end

local function testItCanBeRemoved(force, entity, motion)
  motion.add(entity)
  force.add(entity, "someForce")
  force.remove(entity)    
  assert(force.has(entity) == false, "Should have been removed")
end

local function testItBlocksRemovingMotion(force, entity, motion)
  motion.add(entity)
  force.add(entity, "someForce")
  assert(pcall(function() motion.remove(entity) end) == false, "It should block removing Motion")
end

local function testItCanBeAssignedForce(force, entity, motion)
  motion.add(entity)
  force.add(entity, "someForce")
  force.get(entity):setForce("someForce", 5,10)
  local x, y = force.get(entity):getForce("someForce")
  assert(x == 5, "X should be 5")
  assert(y == 10, "Y should be 10")
end

local function testItCanBeAssignedMultipleForces(force, entity, motion)
  motion.add(entity)
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

local function testYouCanGetSumOfForce(force, entity, motion)
  motion.add(entity)
  force.add(entity, "someForce")
  force.add(entity, "someOtherForce")
  force.get(entity):setForce("someForce", 5,10)
  force.get(entity):setForce("someOtherForce", 3,6)
  local x, y = force.get(entity):getSumForce()
  assert(x == 8, "X should be 8")
  assert(y == 16, "Y should be 16")
end

local function testYouCanRemoveAForceByName(force, entity, motion)
  motion.add(entity)
  force.add(entity, "someForce")
  force.add(entity, "someOtherForce")
  force.get(entity):removeByName("someForce")
  assert(pcall(function() force.get(entity):getForce("someForce") end) == false, "Should no longer be able to get this")
end

local function testYouCanModifyAForceByName(force, entity, motion)
  motion.add(entity)
  force.add(entity, "someForce")
  force.add(entity, "someOtherForce")
  force.get(entity):setForce("someForce", 6, 9)
  force.get(entity):updateForce("someForce", 3, 4)
  local x, y = force.get(entity):getForce("someForce")
  assert(x == 9, "X should be 9")
  assert(y == 13, "Y should be 13")

end

return function()
  local p = require "classes/components/collision/position"()  
  local m = require "classes/components/movement/motion"(p)  
  local f = require "classes/components/movement/force"(m)
  local e = require "classes/core/newentity"
  
  local function makeEntity()
    local ent = e()
    p.add(ent)
    return ent
  end
  
  testItRequiresMotion(f, makeEntity(), m)
  testItCanBeRemoved(f, makeEntity(), m)
  testItCanBeAssignedForce(f, makeEntity(), m)
  testItBlocksRemovingMotion(f, makeEntity(), m)
  testItCanBeAssignedMultipleForces(f, makeEntity(), m)
  testYouCanGetSumOfForce(f, makeEntity(), m)
  testYouCanRemoveAForceByName(f, makeEntity(), m) 
  testYouCanModifyAForceByName(f, makeEntity(), m)
end