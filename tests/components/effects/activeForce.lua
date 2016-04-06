function testWhenItBecomesActiveItSetsTheGivenForce(activeForce, entityFac, position, motion, force, rulestate)
  local entity = entityFac()
end

function testWhenItBecomesInactiveItRemovesTheGivenForce(activeForce, entityFac, position, motion, force, rulestate)
  
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