function testWhenItBecomesActiveItSetsTheGivenForce(activeForce, entityFac, position, motion, force, switchboard)
  local entity = entityFac()
  activeForce.add(entity, "someSwitch", {x = 50, y = 20})
  switchboard.get(entity):setActive("someSwitch")
  local forceX, forceY = force.get(entity):getSumForce()
  assert(forceX == 50, "Force X component should be 50")
  assert(forceY == 20, "Force Y component should be 20")
  
end

function testWhenItBecomesInactiveItRemovesTheGivenForce(activeForce, entityFac, position, motion, force, switchboard)
  local entity = entityFac()
  activeForce.add(entity, "someSwitch", {x = 50, y = 20})
  switchboard.get(entity):setActive("someSwitch")
  switchboard.get(entity):setInactive("someSwitch")
  local forceX, forceY = force.get(entity):getSumForce()
  assert(forceX == 0, "Force X component should be 0")
  assert(forceY == 0, "Force Y component should be 0")
end

return function()  
  local p = require "classes/components/collision/position"()  
  local m = require "classes/components/movement/motion"(p)  
  local f = require "classes/components/movement/force"(m)
  local s = require "classes/components/switchboard"()
  local e = require "classes/core/newentity"
  local af = require "classes/components/effects/activeForce"(s, f)
  local function makeEntity()
    local ent = e()
    p.add(ent)
    m.add(ent)
    f.add(ent)
    s.add(ent)    
    return ent
  end

  testWhenItBecomesActiveItSetsTheGivenForce(af, makeEntity, p, m, f, s)
  testWhenItBecomesInactiveItRemovesTheGivenForce(af, makeEntity, p, m, f, s)

end