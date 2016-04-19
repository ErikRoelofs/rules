local function testItCanOnlyAttachToComponentsWithswitchboard(keytrigger, entity, switchboard, inputHandler)
  assert( false == pcall( function() keytrigger.add(entity, "someSwitch", "q", inputHandler) end ), "Should not be possible to add a keytrigger to an entity without switchboard" )  
end

local function testItBlocksRemovingswitchboardFromComponents(keytrigger, entity, switchboard, inputHandler)
  switchboard.add(entity)
  keytrigger.add(entity, "someSwitch", "q", inputHandler)
  
  assert( false == pcall( function() switchboard.remove(entity) end ), "Should not be possible to remove switchboard if you have triggerKey" )
end

local function testItAddsATriggerToInputHandler(keytrigger, entity, switchboard, inputHandler)
  switchboard.add(entity)
  assert(inputHandler:getNumTriggersForKey("q") == 0, "Should have no triggers now")
  keytrigger.add(entity, "someSwitch", "q", inputHandler)  
  assert(inputHandler:getNumTriggersForKey("q") == 1, "Should have one trigger now")
end

local function testOnKeyDownItWillSetComponentToActive(keytrigger, entity, switchboard, inputHandler)
  switchboard.add(entity)
  keytrigger.add(entity, "someSwitch", "q", inputHandler)  
  assert(entity:component("switchboard"):isActive("someSwitch") == false, "Component should be inactive now")
  inputHandler:keyDown("q")
  assert(entity:component("switchboard"):isActive("someSwitch") == true, "Component should be active now")
end

local function testOnKeyUpItWillSetComponentToInactive(keytrigger, entity, switchboard, inputHandler)
  switchboard.add(entity)
  keytrigger.add(entity, "someSwitch", "q", inputHandler)
  entity:component("switchboard"):setActive("someSwitch")
  assert(entity:component("switchboard"):isActive("someSwitch") == true, "Component should be active now")
  inputHandler:keyUp("q")
  assert(entity:component("switchboard"):isActive("someSwitch") == false, "Component should be inactive now")
  
end

local function testItAcceptsMultipleKeyTriggers(keytrigger, entity, switchboard, inputHandler)
  switchboard.add(entity)
  keytrigger.add(entity, "someSwitch", "q", inputHandler)
  keytrigger.add(entity, "someOtherSwitch", "w", inputHandler)
  
  inputHandler:keyDown("q")
  assert(entity:component("switchboard"):isActive("someSwitch") == true, "Component should be active now")
  assert(entity:component("switchboard"):isActive("someOtherSwitch") == false, "Component should be inactive now")
  
  inputHandler:keyDown("w")
  assert(entity:component("switchboard"):isActive("someOtherSwitch") == true, "Component should be active now")
  
end

local function testOnRemoveItWillUnregisterKeyTriggers(keytrigger, entity, switchboard, inputHandler)
  switchboard.add(entity)
  keytrigger.add(entity, "someSwitch", "q", inputHandler)
  keytrigger.add(entity, "someOtherSwitch", "w", inputHandler)
  keytrigger.remove(entity)
  assert(inputHandler:getNumTriggersForKey("q") == 0, "Should have no triggers now")
  assert(inputHandler:getNumTriggersForKey("w") == 0, "Should have no triggers now")
  
end

return function()
  local r = require "classes/components/switchboard"()
  local e = require "classes/core/newentity"
  local k = require "classes/components/triggers/key"(r)
  local i = require "classes/core/inputhandler"
  
  testItCanOnlyAttachToComponentsWithswitchboard(k, e(), r, i())
  testItBlocksRemovingswitchboardFromComponents(k, e(), r, i())
  testItAddsATriggerToInputHandler(k, e(), r, i())
  testOnKeyDownItWillSetComponentToActive(k, e(), r, i())
  testOnKeyUpItWillSetComponentToInactive(k, e(), r, i())
  testOnRemoveItWillUnregisterKeyTriggers(k, e(), r, i())
  testItAcceptsMultipleKeyTriggers(k, e(), r, i())
end