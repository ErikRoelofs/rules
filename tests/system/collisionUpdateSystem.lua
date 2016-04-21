local function testItActsOnEntitiesWithPositionAndCollision(colS, eFac, position, collision)
  local e1 = eFac()
  local e2 = eFac()
  local e3 = eFac()
  local e4 = eFac()

  position.add(e1)
  collision.add(e1)
  position.get(e1):setPosition(10,20)
  
  position.add(e2)
  position.get(e2):setPosition(40,50)
  
  colS:update({e1,e2,e3,e4}, 1)
  
  local x,y = collision.get(e1):getShape():center()
  
  assert(x == 10, "X should be 10")
  assert(y == 20, "Y should be 20")
  
  
end

return function()
  local position = require "classes/components/collision/position"()
  local shape = require "classes/components/collision/shape"()
  local HC = require "libraries/hc"
  local collision = require "classes/components/collision/collision"(position, shape, HC)
  
  local system = require "classes/system/collisionUpdateSystem"(position, collision)
  local e = require "classes/core/newentity"
  
  local eFac = function()
    local ent = e()
    shape.add(ent, shape.point())    
    return ent
  end

  testItActsOnEntitiesWithPositionAndCollision(system, eFac, position, collision)  
  
end