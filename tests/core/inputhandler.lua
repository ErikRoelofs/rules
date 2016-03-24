local function testItCanAddTriggersForAKey(inputHandler)
  -- trigger 1
  -- trigger 2  
end

local function testItResolvesKeydownForAddedTriggers(inputHandler)
  
end

local function testItResolvesKeydownForAddedTriggersOnlyOnTheSpecificKey(inputHandler)
  
end

local function testItResolvesKeyupForAddedTriggers(inputHandler)
  
end

local function testItResolvesKeyupForAddedTriggersOnlyOnTheSpecificKey(inputHandler)
  
end

local function testItCanGetTriggersForAKey(inputHandler)

end

local function testItCanGetTriggersForAKeyIfThereAreNone(inputHandler)

end

local function testItCanCountTriggersForAKey(inputHandler)

end

local function testItCanRemoveTriggers(inputHandler)

end

local function testItCannotRemoveUnknownTriggers(inputHandler)
  
end

return function()
  
  local i = require "classes/core/inputhandler"
  
  testItCanAddTriggersForAKey(i())
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
