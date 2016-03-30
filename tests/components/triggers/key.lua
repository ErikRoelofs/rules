local function testItCanOnlyAttachToComponentsWithRulestate(keytrigger, entity, rulestate, inputHandler)
  assert( false == pcall( function() keytrigger.add(entity) end ), "Should not be possible to add a keytrigger to an entity without rulestate" )  
end

local function testItBlocksRemovingRulestateFromComponents(keytrigger, entity, rulestate, inputHandler)
  rulestate.add(entity)
  keytrigger.add(entity, "q", inputHandler)
  
  assert( false == pcall( function() rulestate.remove(entity) end ), "Should not be possible to remove rulestate if you have triggerKey" )
end

local function testItAddsATriggerToInputHandler(keytrigger, entity, rulestate, inputHandler)
  rulestate.add(entity)
  assert(inputHandler:getNumTriggersForKey("q") == 0, "Should have no triggers now")
  keytrigger.add(entity, "q", inputHandler)  
  assert(inputHandler:getNumTriggersForKey("q") == 1, "Should have one trigger now")
end

local function testOnKeyDownItWillSetComponentToActive(keytrigger, entity, rulestate, inputHandler)
  rulestate.add(entity)
  keytrigger.add(entity, "q", inputHandler)  
  assert(entity:component("ruleState"):isActive() == false, "Component should be inactive now")
  inputHandler:keyDown("q")
  assert(entity:component("ruleState"):isActive() == true, "Component should be active now")
end

local function testOnKeyUpItWillSetComponentToInactive(keytrigger, entity, rulestate, inputHandler)
  rulestate.add(entity)
  keytrigger.add(entity, "q", inputHandler)
  entity:component("ruleState"):setActive()
  assert(entity:component("ruleState"):isActive() == true, "Component should be active now")
  inputHandler:keyUp("q")
  assert(entity:component("ruleState"):isActive() == false, "Component should be inactive now")
  
end

local function testOnRemoveItWillUnregisterKeyTrigger(keytrigger, entity, rulestate, inputHandler)
  rulestate.add(entity)
  keytrigger.add(entity, "q", inputHandler)
  keytrigger.remove(entity)
  assert(inputHandler:getNumTriggersForKey("q") == 0, "Should have no triggers now")
end

return function()
  local r = require "classes/components/rulestate"()
  local e = require "classes/core/newentity"
  local k = require "classes/components/triggers/key"(r)
  local i = require "classes/core/inputhandler"
  
  testItCanOnlyAttachToComponentsWithRulestate(k, e(), r, i())
  testItBlocksRemovingRulestateFromComponents(k, e(), r, i())
  testItAddsATriggerToInputHandler(k, e(), r, i())
  testOnKeyDownItWillSetComponentToActive(k, e(), r, i())
  testOnKeyUpItWillSetComponentToInactive(k, e(), r, i())
  testOnRemoveItWillUnregisterKeyTrigger(k, e(), r, i())
end