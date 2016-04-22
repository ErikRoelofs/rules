local function testItCanOnlyAttachToComponentsWithswitchboard(collision, eFac, switchboard)
  local entity = eFac()
  assert( false == pcall( function() collision.add(entity, "someSwitch", {}) end ), "Should not be possible to add a collision to an entity without switchboard" )  
end

local function testItBlocksRemovingWwitchboardFromComponents(collision, eFac, switchboard)
  local entity = eFac()
  switchboard.add(entity)
  collision.add(entity, "someSwitch", {})
  
  assert( false == pcall( function() switchboard.remove(entity) end ), "Should not be possible to remove switchboard if you have collision" )
end

local function testItAcceptsComponentsToCheck(collision, eFac, switchboard, simple)
  local entity = eFac()
  local bump = eFac()
  local check = simple("check")
  switchboard.add(entity)
  collision.add(entity, "someSwitch", {check})

  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == false, "It should not be active.")
  
  check.add(bump)
  
  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == true, "It should be active.")
  
end

local function testItOnlySetsTheSwitchIfAllRequiredCollisionsArePresent(collision, eFac, switchboard, simple)
  local entity = eFac()
  local bump = eFac()
  local check = simple("check")
  local morecheck = simple("morecheck")
  local mostcheck = simple("mostcheck")
  switchboard.add(entity)
  collision.add(entity, "someSwitch", {check, morecheck, mostcheck})

  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == false, "It should not be active.")
  
  check.add(bump)  
  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == false, "It should not be active.")
  
  morecheck.add(bump)  
  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == false, "It should not be active.")

  mostcheck.add(bump)  
  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == true, "It should be active.")

end

local function testItAllowsMultipleCollisionSwitches(collision, eFac, switchboard, simple)
  local entity = eFac()
  local bump = eFac()
  local check = simple("check")
  local otherCheck = simple("otherCheck")
  switchboard.add(entity)
  collision.add(entity, "someSwitch", {check})
  collision.add(entity, "someOtherSwitch", {otherCheck})

  check.add(bump)
  
  collision.get(entity):resolve(bump, {x = 5, y = 3})
  assert(switchboard.get(entity):isActive("someSwitch") == true, "It should be active.")
  assert(switchboard.get(entity):isActive("someOtherSwitch") == false, "It should not be active.")

end

return function()
  local r = require "classes/components/switchboard"()
  local e = require "classes/core/newentity"
  local c = require "classes/components/triggers/collision"(r)  
  local s = require "classes/components/simple"()
  
  testItCanOnlyAttachToComponentsWithswitchboard(c, e, r, s)
  testItBlocksRemovingWwitchboardFromComponents(c, e, r, s)
  testItAcceptsComponentsToCheck(c, e, r, s)
  testItOnlySetsTheSwitchIfAllRequiredCollisionsArePresent(c, e, r, s)
  testItAllowsMultipleCollisionSwitches(c, e, r, s)
  
  
end