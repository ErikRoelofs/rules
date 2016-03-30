local function testItExists(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  assert(inventory.has(entity) == true, "It should be there")
end

local function testItCanBeRemoved(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  inventory.remove(entity)    
  assert(inventory.has(entity) == false, "Should have been removed")
end

local function testYouCanPlaceItemsInAnInventory(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  carryable.add(otherEntity)
  inventory.get(entity):placeInside(otherEntity)
  assert( inventory.get(entity):countItems() == 1, "Should be one item inside." )
end

local function testYouCannotPlaceNonCarryableItemsInAnInventory(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  assert( pcall ( function() inventory.get(entity):placeInside(otherEntity) end ) == false, "Should throw an error" )
end

local function testYouCanRecoverItemsFromAnInventory(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  carryable.add(otherEntity)
  inventory.get(entity):placeInside(otherEntity)
  local items = inventory.get(entity):getItems()
  assert( items[1] == otherEntity, "Should be the same item inside." )
end

local function testYouCanRemoveItemsFromAnInventory(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  carryable.add(otherEntity)
  inventory.get(entity):placeInside(otherEntity)
  inventory.get(entity):removeFrom(otherEntity)
  assert( inventory.get(entity):countItems() == 0, "Should be empty again." )
  
end

local function testYouCannotRemoveWhatIsNotThere(inventory, entity, carryable, otherEntity)
  inventory.add(entity)
  carryable.add(otherEntity)  
  assert( pcall( function() inventory.get(entity):removeFrom(otherEntity) end ) == false, "Should not be able to remove this.")
  
end

return function()
  local c = require "classes/components/carryable"()
  local p = require "classes/components/inventory"(c)
  local e = require "classes/core/newentity"
  
  testItExists(p, e(), c, e())
  testItCanBeRemoved(p, e(), c, e())
  testYouCanPlaceItemsInAnInventory(p, e(), c, e())
  testYouCannotPlaceNonCarryableItemsInAnInventory(p, e(), c, e())
  testYouCanRecoverItemsFromAnInventory(p, e(), c, e())
  testYouCanRemoveItemsFromAnInventory(p, e(), c, e())
  testYouCannotRemoveWhatIsNotThere(p, e(), c, e())
end