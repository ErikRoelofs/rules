local function testItCanAddTriggersForAKey(inputHandler)
  inputHandler:addTriggerForKey("q", "name", "trigger")
  inputHandler:addTriggerForKey("q", "other_name", "trigger")
end

local function testItCanAddTriggersWithTheSameNameForDifferentKeys(inputHandler)
  inputHandler:addTriggerForKey("q", "name", "trigger")
  inputHandler:addTriggerForKey("w", "name", "trigger")
end

local function testItCannotAddTriggersWithTheSameNameForTheSameKey(inputHandler)
  inputHandler:addTriggerForKey("q", "name", "trigger")
  assert( false == pcall( function() inputHandler:addTriggerForKey("q", "name", "trigger") end ), "Should not be possible to add a trigger with the same name twice" )  
end

local function testItResolvesKeydownForAddedTriggers(inputHandler)
  local done = false
  local done2 = false
  inputHandler:addTriggerForKey("q", "name", {resolve = function(self, event) if event == "keydown" then done = true end end})
  inputHandler:addTriggerForKey("q", "name_2", {resolve = function(self, event) if event == "keydown" then done2 = true end end})
  inputHandler:keyDown("q")
  assert(done == true, "Function should have been resolved")
  assert(done2 == true, "Other function should have been resolved")
end

local function testItResolvesKeydownForAddedTriggersOnlyOnTheSpecificKey(inputHandler)
  local done = false
  local done2 = false
  inputHandler:addTriggerForKey("q", "name", {resolve = function(self, event) done = true end})
  inputHandler:addTriggerForKey("q", "name_2", {resolve = function(self, event) done2 = true end})
  inputHandler:keyDown("w")
  assert(done == false, "Function should not have been resolved")
  assert(done2 == false, "Other function should not have been resolved")  
end

local function testItResolvesKeyupForAddedTriggers(inputHandler)
  local done = false
  local done2 = false
  inputHandler:addTriggerForKey("q", "name", {resolve = function(self, event) if event == "keyup" then done = true end end})
  inputHandler:addTriggerForKey("q", "name_2", {resolve = function(self, event) if event == "keyup" then done2 = true end end})
  inputHandler:keyUp("q")
  assert(done == true, "Function should have been resolved")
  assert(done2 == true, "Other function should have been resolved")  
end

local function testItResolvesKeyupForAddedTriggersOnlyOnTheSpecificKey(inputHandler)
  local done = false
  local done2 = false
  inputHandler:addTriggerForKey("q", "name", {resolve = function(self, event) done = true end})
  inputHandler:addTriggerForKey("q", "name_2", {resolve = function(self, event) done2 = true end})
  inputHandler:keyUp("w")
  assert(done == false, "Function should not have been resolved")
  assert(done2 == false, "Other function should not have been resolved")    
end

local function testItCanGetTriggersForAKey(inputHandler)
  local trigger = { name = "trigger" }
  inputHandler:addTriggerForKey("q", "trigger", trigger)
  local returned = inputHandler:getTriggersForKey("q")
  
  assert(type(returned) == "table", "Returned value was not a table")  
  assert(returned.trigger == trigger, "Did not get back the expected trigger")
end

local function testItCanGetTriggersForAKeyIfThereAreNone(inputHandler)
  local returned = inputHandler:getTriggersForKey("q")  
  assert(type(returned) == "table", "Returned value was not a table")    
end

local function testItCanCountTriggersForAKey(inputHandler)
  local trigger = { name = "trigger" }
  inputHandler:addTriggerForKey("q", "trigger", trigger)
  assert( inputHandler:getNumTriggersForKey("q") == 1, "Return value should be equal to 1" )
end

local function testItCanRemoveTriggers(inputHandler)
  local trigger = { name = "trigger" }
  inputHandler:addTriggerForKey("q", "trigger", trigger)
  inputHandler:removeTriggerForKey("q", "trigger")
  assert( inputHandler:getNumTriggersForKey("q") == 0, "Return value should be equal to 0" )
end

local function testItCannotRemoveUnknownTriggers(inputHandler)
  assert( false == pcall( function() inputHandler:removeTriggerForKey("q", "trigger") end ), "Should not be possible to remove a trigger with an unknown name" )  
end

return function()
  
  local i = require "classes/core/inputhandler"
  
  testItCanAddTriggersForAKey(i())
  testItCanAddTriggersWithTheSameNameForDifferentKeys(i())
  testItCannotAddTriggersWithTheSameNameForTheSameKey(i())
  testItResolvesKeydownForAddedTriggers(i())
  testItResolvesKeydownForAddedTriggersOnlyOnTheSpecificKey(i())
  testItResolvesKeyupForAddedTriggers(i())
  testItResolvesKeyupForAddedTriggersOnlyOnTheSpecificKey(i())
  testItCanGetTriggersForAKey(i())
  testItCanGetTriggersForAKeyIfThereAreNone(i())
  testItCanCountTriggersForAKey(i())
  testItCanRemoveTriggers(i())
  testItCannotRemoveUnknownTriggers(i())
end
