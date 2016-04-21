function testWhenItBecomesActiveItSetsTheGivenDrag(activeDrag, entityFac, position, motion, drag, switchboard)
  local entity = entityFac()
  activeDrag.add(entity, "someSwitch", 30)
  switchboard.get(entity):setActive("someSwitch")
  local dragA = drag.get(entity):getDragAmount()
  assert(dragA == 30, "Drag amount should be 30")  
end

function testWhenItBecomesInactiveItRemovesTheGivenDrag(activeDrag, entityFac, position, motion, drag, switchboard)
  local entity = entityFac()
  activeDrag.add(entity, "someSwitch", 30)
  switchboard.get(entity):setActive("someSwitch")
  switchboard.get(entity):setInactive("someSwitch")
  local dragA = drag.get(entity):getDragAmount()
  assert(dragA == 5, "Drag amount should be 5 again") 
end

function testWhenItIsRemovedItRestoresTheDrag(activeDrag, entityFac, position, motion, drag, switchboard)
  local entity = entityFac()
  activeDrag.add(entity, "someSwitch", 30)
  switchboard.get(entity):setActive("someSwitch")
  activeDrag.remove(entity)
  local dragA = drag.get(entity):getDragAmount()
  assert(dragA == 5, "Drag amount should be 5 again")   
end


return function()  
  local p = require "classes/components/collision/position"()  
  local m = require "classes/components/movement/motion"(p)  
  local f = require "classes/components/movement/force"(m)
  local d = require "classes/components/movement/drag"(f)
  local s = require "classes/components/switchboard"()
  local e = require "classes/core/newentity"
  local af = require "classes/components/effects/activeDrag"(s, d)
  local function makeEntity()
    local ent = e()
    p.add(ent)
    m.add(ent)
    f.add(ent)
    d.add(ent, 5)
    s.add(ent)    
    return ent
  end

  testWhenItBecomesActiveItSetsTheGivenDrag(af, makeEntity, p, m, d, s)
  testWhenItBecomesInactiveItRemovesTheGivenDrag(af, makeEntity, p, m, d, s)  
  testWhenItIsRemovedItRestoresTheDrag(af, makeEntity, p, m, d, s)
end