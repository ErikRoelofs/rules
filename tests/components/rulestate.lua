local function testItCanBeAddedToAnEntity(rulestate, entity)
  rulestate.add(entity)  
end

local function testItCanBeRemovedFromAnEntity(rulestate, entity)
  rulestate.add(entity)
  rulestate.remove(entity)
end

local function testItCanBeSetToActive(rulestate, entity)
  rulestate.add(entity)
  entity:entity("ruleState"):setActive()
  assert(entity:entity("ruleState"):isActive() == true, "It should be active")
end

local function testItCanBeSetToInactive(rulestate, entity)
  rulestate.add(entity)
  entity:entity("ruleState"):setInactive()
  assert(entity:entity("ruleState"):isActive() == false, "It should be inactive")  
end

local function testItWillTriggerAttachedEffectsWhenItBecomesActive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  entity:entity("ruleState"):addEffect("effect", {becomesActive = function() done = true end})
  entity:entity("ruleState"):addEffect("effect2", {becomesActive = function() done2 = true end})
  entity:entity("ruleState"):setActive()
  assert(done == true, "It should be called")
  assert(done2 == true, "It should also be called")
end

local function testItWillTriggerAttachedEffectsWhenItBecomesInactive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  entity:entity("ruleState"):setActive()
  entity:entity("ruleState"):addEffect("effect", {becomesInactive = function() done = true end})
  entity:entity("ruleState"):addEffect("effect2", {becomesInactive = function() done2 = true end})  
  entity:entity("ruleState"):setInactive()
  assert(done == true, "It should be called")
  assert(done2 == true, "It should also be called")  
end

local function testItWillNotTriggerAttachedEffectsWhenItAlreadyWasActive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  entity:entity("ruleState"):setActive()
  entity:entity("ruleState"):addEffect("effect", {becomesActive = function() done = true end})
  entity:entity("ruleState"):addEffect("effect2", {becomesActive = function() done2 = true end})
  entity:entity("ruleState"):setActive()
  assert(done == false, "It should not be called")
  assert(done2 == false, "It should also not be called")
  
end

local function testItWillNotTriggerAttachedEffectsWhenItAlreadyWasInactive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  entity:entity("ruleState"):setInactive()
  entity:entity("ruleState"):addEffect("effect", {becomesInactive = function() done = true end})
  entity:entity("ruleState"):addEffect("effect2", {becomesInactive = function() done2 = true end})  
  entity:entity("ruleState"):setInactive()
  assert(done == false, "It should not be called")
  assert(done2 == false, "It should also not be called")  
end


return function()
  local r = require "classes/components/rulestate"
  local e = require "classes/core/newentity"
  
  testItCanBeAddedToAnEntity(r,e())
  testItCanBeRemovedFromAnEntity(r,e())
  testItCanBeSetToActive(r,e())
  testItCanBeSetToInactive(r,e())
  testItWillTriggerAttachedEffectsWhenItBecomesActive(r,e())
  testItWillTriggerAttachedEffectsWhenItBecomesInactive(r,e())
  testItWillNotTriggerAttachedEffectsWhenItAlreadyWasActive(r,e())
  testItWillNotTriggerAttachedEffectsWhenItAlreadyWasInactive(r,e())
  
end