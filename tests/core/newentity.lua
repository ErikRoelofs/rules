local function testItAddsComponents(entity)
  entity:addComponent("someName", {name="component"})
  entity:addComponent("someOtherName", {name="component"})
end

local function testItCannotAddTheSameComponentTwice(entity)
  entity:addComponent("someName", {name="component"})
  assert( false == pcall( function() entity:addComponent("someName", {name="component"}) end ), "Adding the same component twice should raise an error" )
end

local function testItCanGetComponents(entity)
  local component = {name="component"}
  entity:addComponent("someName", component)
  assert( component == entity:component("someName"), "Could not get the component we just set" )
end

local function testItCanCheckForComponents(entity)
  local component = {name="component"}
  entity:addComponent("someName", component)
  assert(entity:hasComponent("someName") == true, "Registered component is not found")
  assert(entity:hasComponent("someOtherName") == false, "Unregistered component is found")  
end

local function testItCanNotGetUnknownComponents(entity)
  assert( false == pcall( function() entity:component("someName") end ), "Getting an unregistered component should raise an error" )
end

local function testItCanRemoveComponents(entity)
  local component = {name="component", allowRemoveOtherComponent = function() return true end, remove = function(self) self.removed = true end}
  entity:addComponent("someName", component)
  
  entity:removeComponent("someName")
  assert(entity:hasComponent("someName") == false, "Component should have been removed, but it was not")
  assert(component.removed == true, "Components remove method should have been called")
end

local function testItCanNotRemoveLinkedComponents(entity)
  local component = {name="component", allowRemoveOtherComponent = function() return true end, remove = function(self) self.removed = true end}
  local linkedComponent = {name="component", allowRemoveOtherComponent = function() return false end, remove = function(self) self.removed = true end}
  entity:addComponent("someName", component)
  entity:addComponent("someOtherName", linkedComponent)
  
  assert( false == pcall( function() entity:removeComponent("someName") end ), "Should not be possible to remove a linked component" )
  assert( component.removed ~= true, "Component remove function should not have been called" )
end

return function()  
  local e = require "classes/core/newentity"
  testItAddsComponents(e())
  testItCannotAddTheSameComponentTwice(e())
  testItCanGetComponents(e())
  testItCanCheckForComponents(e())
  testItCanNotGetUnknownComponents(e())
  testItCanRemoveComponents(e())
  testItCanNotRemoveLinkedComponents(e())
end