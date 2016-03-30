local function testItCanBeAddedToAnEntity(rulestate, entity)
  rulestate.add(entity)  
end

local function testItCanBeCheckedOnAnEntity(rulestate, entity)
  rulestate.add(entity)  
  assert(rulestate.has(entity) == true, "It should have the component")
end


local function testItCanBeRemovedFromAnEntity(rulestate, entity)
  rulestate.add(entity)
  rulestate.remove(entity)
end

local function testItCanBeSetToActive(rulestate, entity)
  rulestate.add(entity)  
  rulestate.get(entity):setActive()
  assert(rulestate.get(entity):isActive() == true, "It should be active")
end

local function testItCanBeSetToInactive(rulestate, entity)
  rulestate.add(entity)
  rulestate.get(entity):setInactive()
  assert(rulestate.get(entity):isActive() == false, "It should be inactive")  
end

local function testItWillTriggerAttachedEffectsWhenItBecomesActive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  rulestate.get(entity):addEffect("effect", {becomesActive = function() done = true end})
  rulestate.get(entity):addEffect("effect2", {becomesActive = function() done2 = true end})
  rulestate.get(entity):setActive()
  assert(done == true, "It should be called")
  assert(done2 == true, "It should also be called")
end

local function testItWillTriggerAttachedEffectsWhenItBecomesInactive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  rulestate.get(entity):setActive()
  rulestate.get(entity):addEffect("effect", {becomesInactive = function() done = true end})
  rulestate.get(entity):addEffect("effect2", {becomesInactive = function() done2 = true end})  
  rulestate.get(entity):setInactive()
  assert(done == true, "It should be called")
  assert(done2 == true, "It should also be called")  
end

local function testItWillNotTriggerAttachedEffectsWhenItAlreadyWasActive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  rulestate.get(entity):setActive()
  rulestate.get(entity):addEffect("effect", {becomesActive = function() done = true end})
  rulestate.get(entity):addEffect("effect2", {becomesActive = function() done2 = true end})
  rulestate.get(entity):setActive()
  assert(done == false, "It should not be called")
  assert(done2 == false, "It should also not be called")
  
end

local function testItWillNotTriggerAttachedEffectsWhenItAlreadyWasInactive(rulestate, entity)
  local done = false
  local done2 = false
  rulestate.add(entity)
  rulestate.get(entity):setInactive()
  rulestate.get(entity):addEffect("effect", {becomesInactive = function() done = true end})
  rulestate.get(entity):addEffect("effect2", {becomesInactive = function() done2 = true end})  
  rulestate.get(entity):setInactive()
  assert(done == false, "It should not be called")
  assert(done2 == false, "It should also not be called")  
end


return function()
  local r = require "classes/components/rulestate"()
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