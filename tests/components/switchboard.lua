local function testItCanBeAddedToAnEntity(switchboard, entity)
  switchboard.add(entity)  
end

local function testItCanBeCheckedOnAnEntity(switchboard, entity)
  switchboard.add(entity)  
  assert(switchboard.has(entity) == true, "It should have the component")
end


local function testItCanBeRemovedFromAnEntity(switchboard, entity)
  switchboard.add(entity)
  switchboard.remove(entity)
end

local function testASwitchCanBeRegistered(switchboard, entity)
  switchboard.add(entity)  
  switchboard.get(entity):registerSwitch("someSwitch")
  assert(switchboard.get(entity):hasSwitch("someSwitch") == true, "It should have the new switch")
end

local function testAUsedSwitchCannotBeRegistered(switchboard, entity)
  switchboard.add(entity)  
  switchboard.get(entity):registerSwitch("someSwitch")
  assert(pcall(function() switchboard.get(entity):registerSwitch("someSwitch") end) == false, "Should not be possible to register it twice" )
  
end

local function testARegisteredSwitchCanBeActivated(switchboard, entity)
  switchboard.add(entity)  
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):setActive("someSwitch")
  assert(switchboard.get(entity):isActive("someSwitch") == true, "It should be active")
end

local function testAnUnregisteredSwitchCannotBeActivated(switchboard, entity)
  switchboard.add(entity)    
  assert(pcall(function() switchboard.get(entity):setActive("someSwitch") end) == false, "Unknown switch should not be triggerable")
end

local function testSettingOneSwitchDoesNotAffectOthers(switchboard, entity)
  switchboard.add(entity) 
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):registerSwitch("someOtherSwitch")
  switchboard.get(entity):setActive("someSwitch")
  assert(switchboard.get(entity):isActive("someOtherSwitch") == false, "It should not be active")
  
end

local function testARegisteredSwitchCanBeDeactivated(switchboard, entity)
  switchboard.add(entity)  
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):setActive("someSwitch")
  switchboard.get(entity):setInactive("someSwitch")
  assert(switchboard.get(entity):isActive("someSwitch") == false, "It should not be active")
end

local function testAnUnregisteredSwitchCannotBeDeactivated(switchboard, entity)
  switchboard.add(entity)    
  assert(pcall(function() switchboard.get(entity):setInactive("someSwitch") end) == false, "Unknown switch should not be triggerable")
end

local function testUnsettingOneSwitchDoesNotAffectOthers(switchboard, entity)
  switchboard.add(entity) 
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):registerSwitch("someOtherSwitch")
  switchboard.get(entity):setActive("someSwitch")
  switchboard.get(entity):setActive("someOtherSwitch")
  switchboard.get(entity):setInactive("someSwitch")
  assert(switchboard.get(entity):isActive("someOtherSwitch") == true, "It should still be active")
  
end

local function testItWillTriggerAttachedEffectsWhenItBecomesActive(switchboard, entity)
  local done = false
  local done2 = false
  switchboard.add(entity)
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):addEffect("someSwitch", "effect", {becomesActive = function() done = true end})
  switchboard.get(entity):addEffect("someSwitch", "effect2", {becomesActive = function() done2 = true end})
  switchboard.get(entity):setActive("someSwitch")
  assert(done == true, "It should be called")
  assert(done2 == true, "It should also be called")
end

local function testItWillTriggerAttachedEffectsWhenItBecomesInactive(switchboard, entity)
  local done = false
  local done2 = false
  switchboard.add(entity)
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):setActive("someSwitch")
  switchboard.get(entity):addEffect("someSwitch", "effect", {becomesInactive = function() done = true end})
  switchboard.get(entity):addEffect("someSwitch", "effect2", {becomesInactive = function() done2 = true end})  
  switchboard.get(entity):setInactive("someSwitch")
  assert(done == true, "It should be called")
  assert(done2 == true, "It should also be called")  
end

local function testItWillNotTriggerAttachedEffectsWhenItAlreadyWasActive(switchboard, entity)
  local done = false
  local done2 = false
  switchboard.add(entity)
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):setActive("someSwitch")
  switchboard.get(entity):addEffect("someSwitch", "effect", {becomesActive = function() done = true end})
  switchboard.get(entity):addEffect("someSwitch", "effect2", {becomesActive = function() done2 = true end})
  switchboard.get(entity):setActive("someSwitch")
  assert(done == false, "It should not be called")
  assert(done2 == false, "It should also not be called")
  
end

local function testItWillNotTriggerAttachedEffectsWhenItAlreadyWasInactive(switchboard, entity)
  local done = false
  local done2 = false
  switchboard.add(entity)
  switchboard.get(entity):registerSwitch("someSwitch")
  switchboard.get(entity):setInactive("someSwitch")
  switchboard.get(entity):addEffect("someSwitch", "effect", {becomesInactive = function() done = true end})
  switchboard.get(entity):addEffect("someSwitch", "effect2", {becomesInactive = function() done2 = true end})  
  switchboard.get(entity):setInactive("someSwitch")
  assert(done == false, "It should not be called")
  assert(done2 == false, "It should also not be called")  
end


return function()
  local switchboard = require "classes/components/switchboard"()
  local e = require "classes/core/newentity"
  
  testItCanBeAddedToAnEntity(switchboard,e())
  testItCanBeCheckedOnAnEntity(switchboard,e())
  testItCanBeRemovedFromAnEntity(switchboard,e())
  testASwitchCanBeRegistered(switchboard,e())
  testAUsedSwitchCannotBeRegistered(switchboard,e())
  testARegisteredSwitchCanBeActivated(switchboard,e())
  testAnUnregisteredSwitchCannotBeActivated(switchboard,e())
  testSettingOneSwitchDoesNotAffectOthers(switchboard,e())  
  
  testARegisteredSwitchCanBeDeactivated(switchboard,e())
  testAnUnregisteredSwitchCannotBeDeactivated(switchboard,e())
  testUnsettingOneSwitchDoesNotAffectOthers(switchboard,e())
  
  testItWillTriggerAttachedEffectsWhenItBecomesActive(switchboard,e())
  testItWillTriggerAttachedEffectsWhenItBecomesInactive(switchboard,e())
  testItWillNotTriggerAttachedEffectsWhenItAlreadyWasActive(switchboard,e())
  testItWillNotTriggerAttachedEffectsWhenItAlreadyWasInactive(switchboard,e())
end