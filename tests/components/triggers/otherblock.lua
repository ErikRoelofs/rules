local function testItCanOnlyAttachToEntitiesWithRulestate(otherblock, toTrigger, thatTriggers, rulestate)
  assert( false == pcall( function() otherblock.add(toTrigger, thatTriggers) end ), "Should not be possible to add a otherblock to an entity without rulestate" )
  rulestate.add(toTrigger)
  assert( false == pcall( function() otherblock.add(toTrigger, thatTriggers) end ), "Should not be possible to add a otherblock to an entity without rulestate" )
end

local function testItBlocksRemovingRulestateFromThatTriggers(otherblock, toTrigger, thatTriggers, rulestate)
  rulestate.add(toTrigger)
  rulestate.add(thatTriggers)
  otherblock.add(toTrigger, thatTriggers)
  
  assert( false == pcall( function() rulestate.remove(thatTriggers) end ), "Should not be possible to remove rulestate if you have otherBlock" )
end

local function testItBlocksRemovingRulestateFromToTrigger(otherblock, toTrigger, thatTriggers, rulestate)
  rulestate.add(toTrigger)
  rulestate.add(thatTriggers)
  otherblock.add(toTrigger, thatTriggers)
  
  assert( false == pcall( function() rulestate.remove(toTrigger) end ), "Should not be possible to remove rulestate if you have otherBlock" )
end

local function testItSetsOtherBlockToActive(otherblock, toTrigger, thatTriggers, rulestate)
  rulestate.add(toTrigger)
  rulestate.add(thatTriggers)
  otherblock.add(toTrigger, thatTriggers)
  
  thatTriggers:component("ruleState"):setActive()
  assert(toTrigger:component("ruleState"):isActive() == true, "It should be active as well")
  
end

local function testItSetsOtherBlockToInactive(otherblock, toTrigger, thatTriggers, rulestate)
  rulestate.add(toTrigger)
  rulestate.add(thatTriggers)
  otherblock.add(toTrigger, thatTriggers)
  
  thatTriggers:component("ruleState"):setActive()
  assert(toTrigger:component("ruleState"):isActive() == true, "It should be active as well")
  thatTriggers:component("ruleState"):setInactive()
  assert(toTrigger:component("ruleState"):isActive() == false, "It should be inactive as well")
  
end

local function testItCleansUpProperly(otherblock, toTrigger, thatTriggers, rulestate)
  rulestate.add(toTrigger)
  rulestate.add(thatTriggers)
  otherblock.add(toTrigger, thatTriggers)

  otherblock.remove(toTrigger, thatTriggers)
  
  rulestate.remove(toTrigger)
  rulestate.remove(thatTriggers)

end

return function()
  local r = require "classes/components/rulestate"()
  local e = require "classes/core/newentity"
  local o = require "classes/components/triggers/otherblock"
  
  testItCanOnlyAttachToEntitiesWithRulestate(o, e(), e(), r)
  testItBlocksRemovingRulestateFromThatTriggers(o, e(), e(), r)
  testItBlocksRemovingRulestateFromToTrigger(o, e(), e(), r)
  testItSetsOtherBlockToActive(o, e(), e(), r)
  testItSetsOtherBlockToInactive(o, e(), e(), r)
  testItCleansUpProperly(o, e(), e(), r)
end