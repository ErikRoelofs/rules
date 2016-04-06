function testWhenItBecomesActiveItSetsTheGivenForce(activeForce, entityFac, position, motion, force, rulestate)
  local entity = entityFac()
  activeForce.add(entity, {x = 50, y = 20})
  rulestate.get(entity):setActive()
  local forceX, forceY = force.get(entity):getSumForce()
  assert(forceX == 50, "Force X component should be 50")
  assert(forceY == 20, "Force Y component should be 20")
  
end

function testWhenItBecomesInactiveItRemovesTheGivenForce(activeForce, entityFac, position, motion, force, rulestate)
  local entity = entityFac()
  activeForce.add(entity, {x = 50, y = 20})
  rulestate.get(entity):setActive()
  rulestate.get(entity):setInactive()
  local forceX, forceY = force.get(entity):getSumForce()
  assert(forceX == 0, "Force X component should be 0")
  assert(forceY == 0, "Force Y component should be 0")
  
end

return function()  
  local p = require "classes/components/collision/position"()  
  local m = require "classes/components/movement/motion"(p)  
  local f = require "classes/components/movement/force"(m)
  local r = require "classes/components/rulestate"()
  local e = require "classes/core/newentity"
  local af = require "classes/components/effects/activeForce"(r, f)
  local function makeEntity()
    local ent = e()
    p.add(ent)
    m.add(ent)
    f.add(ent)
    r.add(ent)
    return ent
  end

  testWhenItBecomesActiveItSetsTheGivenForce(af, makeEntity, p, m, f, r)
  testWhenItBecomesInactiveItRemovesTheGivenForce(af, makeEntity, p, m, f, r)

end