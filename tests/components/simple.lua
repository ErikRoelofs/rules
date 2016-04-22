local function testItReturnsAWorkingComponent(simpleFactory, entity)
  local cookie = simpleFactory("cookie")
  cookie.add(entity)
  assert(cookie.has(entity) == true, "It should have the component")
end

local function testMultipleComponentsDoNotInteract(simpleFactory, entity)
  local cookie = simpleFactory("cookie")
  cookie.add(entity)
  
  local cake = simpleFactory("cake")
  cake.add(entity)
  
  local icecream = simpleFactory("icecream")  
  
  assert(cookie.has(entity) == true, "It should have the component")
  assert(cake.has(entity) == true, "It should have the component")
  assert(icecream.has(entity) == false, "It should not have the component")
end

local function testEachComponentHasAValue(simpleFactory, entity)
  local cookie = simpleFactory("cookie")
  cookie.add(entity, 10)
  
  local cake = simpleFactory("cake")
  cake.add(entity)
  cake.get(entity):setValue(5)
    
  assert(cookie.get(entity):getValue() == 10, "It should have value 10")
  assert(cake.get(entity):getValue() == 5, "It should have value 5")
  
end

local function testItAcceptsRequirements(simpleFactory, entity)
  local cookie = simpleFactory("cookie")
  cookie.add(entity)
  
  local cake = simpleFactory("cake", {cookie})
  cake.add(entity)
  
  local icecream = simpleFactory("icecream")
  local chocolate = simpleFactory("chocolate", {icecream})
  
  assert(pcall(function() chocolate.add(entity) end) == false, "It should not be possible to add this")
end

local function testARequiredComponentCannotBeRemoved(simpleFactory, entity)
  local cookie = simpleFactory("cookie")
  cookie.add(entity)
  
  local cake = simpleFactory("cake", {cookie})
  cake.add(entity)

  assert(pcall(function() cookie.remove(entity) end) == false, "It should not be possible to remove this")  
end

return function()
  local s = require "classes/components/simple"()
  local e = require "classes/core/newentity"

  function makeEnt()
    local ent = e()
    return ent
  end
  
  testItReturnsAWorkingComponent(s, makeEnt())
  testMultipleComponentsDoNotInteract(s, makeEnt())
  testEachComponentHasAValue(s, makeEnt())
  testItAcceptsRequirements(s, makeEnt())
  testARequiredComponentCannotBeRemoved(s, makeEnt())
end