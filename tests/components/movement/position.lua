local function testItExists(position, entity)
  position.add(entity)
  assert(position.has(entity) == true, "It should be there")
end

local function testItCanBeRemoved(position, entity)
  position.add(entity)
  position.remove(entity)    
  assert(position.has(entity) == false, "Should have been removed")
end

local function testPositionCanBeSet(position, entity)
  position.add(entity)
  position.get(entity):setPosition(50, 60)
  local posX, posY = position.get(entity):getPosition()
  assert(posX == 50, "X position should be 50")
  assert(posY == 60, "Y position should be 60")
end

local function testPositionCanBeModified(position, entity)
  position.add(entity)
  position.get(entity):setPosition(50, 60)
  position.get(entity):movePosition(15, -15)
  local posX, posY = position.get(entity):getPosition()
  assert(posX == 65, "X position should be 65")
  assert(posY == 45, "Y position should be 45")
end

return function()
  local p = require "classes/components/movement/position"()
  local e = require "classes/core/newentity"
  
  testItExists(p, e())
  testItCanBeRemoved(p, e())
  testPositionCanBeSet(p, e())
  testPositionCanBeModified(p, e())
  
end