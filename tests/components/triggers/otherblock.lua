local function testItCanOnlyAttachToEntitiesWithswitchboard(otherblock, toTrigger, thatTriggers, switchboard)
  assert( false == pcall( function() otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch") end ), "Should not be possible to add a otherblock to an entity without switchboard" )
  switchboard.add(toTrigger)
  assert( false == pcall( function() otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch") end ), "Should not be possible to add a otherblock to an entity without switchboard" )
end

local function testItBlocksRemovingswitchboardFromThatTriggers(otherblock, toTrigger, thatTriggers, switchboard)
  switchboard.add(toTrigger)
  switchboard.add(thatTriggers)
  otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch")
  
  assert( false == pcall( function() switchboard.remove(thatTriggers) end ), "Should not be possible to remove switchboard if you have otherBlock" )
end

local function testItBlocksRemovingswitchboardFromToTrigger(otherblock, toTrigger, thatTriggers, switchboard)
  switchboard.add(toTrigger)
  switchboard.add(thatTriggers)
  otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch")
  
  assert( false == pcall( function() switchboard.remove(toTrigger) end ), "Should not be possible to remove switchboard if you have otherBlock" )
end

local function testItSetsOtherBlockToActive(otherblock, toTrigger, thatTriggers, switchboard)
  switchboard.add(toTrigger)
  switchboard.add(thatTriggers)
  otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch")
  
  thatTriggers:component("switchboard"):setActive("listenSwitch")
  assert(toTrigger:component("switchboard"):isActive("targetSwitch") == true, "It should be active as well")
  
end

local function testItSetsOtherBlockToInactive(otherblock, toTrigger, thatTriggers, switchboard)
  switchboard.add(toTrigger)
  switchboard.add(thatTriggers)
  otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch")
  
  thatTriggers:component("switchboard"):setActive("listenSwitch")
  assert(toTrigger:component("switchboard"):isActive("targetSwitch") == true, "It should be active as well")
  thatTriggers:component("switchboard"):setInactive("listenSwitch")
  assert(toTrigger:component("switchboard"):isActive("targetSwitch") == false, "It should be inactive as well")
  
end

local function testItCleansUpProperly(otherblock, toTrigger, thatTriggers, switchboard)
  switchboard.add(toTrigger)
  switchboard.add(thatTriggers)
  otherblock.add(thatTriggers, "listenSwitch", toTrigger, "targetSwitch")

  otherblock.remove(toTrigger, thatTriggers)
  
  switchboard.remove(toTrigger)
  switchboard.remove(thatTriggers)

end

return function()
  local r = require "classes/components/switchboard"()
  local e = require "classes/core/newentity"
  local o = require "classes/components/triggers/otherblock"(r)
  
  testItCanOnlyAttachToEntitiesWithswitchboard(o, e(), e(), r)
  testItBlocksRemovingswitchboardFromThatTriggers(o, e(), e(), r)
  testItBlocksRemovingswitchboardFromToTrigger(o, e(), e(), r)
  testItSetsOtherBlockToActive(o, e(), e(), r)
  testItSetsOtherBlockToInactive(o, e(), e(), r)
  testItCleansUpProperly(o, e(), e(), r)
end