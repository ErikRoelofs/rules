local function testItAddsEntities(entity)
  entity:addEntity("someName", {name="component"})
  entity:addEntity("someOtherName", {name="component"})
end

local function testItCannotAddTheSameEntityTwice(entity)
  entity:addEntity("someName", {name="component"})
  assert( false == pcall( function() entity:addEntity("someName", {name="component"}) end ), "Adding the same component twice should raise an error" )
end

local function testItCanGetEntities(entity)
  local component = {name="component"}
  entity:addEntity("someName", component)
  assert( component == entity:entity("someName"), "Could not get the component we just set" )
end

local function testItCanCheckForEntities(entity)
  local component = {name="component"}
  entity:addEntity("someName", component)
  assert(entity:hasEntity("someName") == true, "Registered component is not found")
  assert(entity:hasEntity("someOtherName") == false, "Unregistered component is found")  
end

local function testItCanNotGetUnknownEntities(entity)
  assert( false == pcall( function() entity:entity("someName") end ), "Getting an unregistered component should raise an error" )
end

local function testItCanRemoveEntities(entity)
  local component = {name="component", allowRemoveOtherEntity = function() return true end, remove = function(self) self.removed = true end}
  entity:addEntity("someName", component)
  
  entity:removeEntity("someName")
  assert(entity:hasEntity("someName") == false, "Component should have been removed, but it was not")
  assert(component.removed == true, "Components remove method should have been called")
end

local function testItCanNotRemoveLinkedEntities(entity)
  local component = {name="component", allowRemoveOtherEntity = function() return true end, remove = function(self) self.removed = true end}
  local linkedComponent = {name="component", allowRemoveOtherEntity = function() return false end, remove = function(self) self.removed = true end}
  entity:addEntity("someName", component)
  entity:addEntity("someOtherName", linkedComponent)
  
  assert( false == pcall( function() entity:removeEntity("someName") end ), "Should not be possible to remove a linked component" )
  assert( component.removed ~= true, "Component remove function should not have been called" )
end

return function()  
  testItAddsEntities(makeEntity())
  testItCannotAddTheSameEntityTwice(makeEntity())
  testItCanGetEntities(makeEntity())
  testItCanCheckForEntities(makeEntity())
  testItCanNotGetUnknownEntities(makeEntity())
  testItCanRemoveEntities(makeEntity())
  testItCanNotRemoveLinkedEntities(makeEntity())
end