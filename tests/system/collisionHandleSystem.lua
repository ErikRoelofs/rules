local function testItSeperatesCollidingEntities(colS, entity, position, collision, HC)
  local x = 0
  local y = 0
  local shape = {}
  local colComp = {
    getShape = function()
      return shape
    end
  }
  
  local posComp = {
    movePosition = function(self, x2, y2)
      x = x2
      y = y2
    end
  }
  
  collision.has = function() return true end
  HC.collisions = function() 
    return { {}, {x=10, y=20} }
  end
  collision.get = function() return colComp end
  position.get = function() return posComp end
  
  colS:update({entity},1)
  
  assert( x == 10, "X should be 10, is: " .. x )
  assert( y == 20, "Y should be 20, is: " .. y )
  
end

local function testItIgnoresNoneCollisionEntities(colS, entity, position, collision, HC)
  
  collision.has = function() return false end  
  collision.get = function() error( "Should never call this." ) end  
  colS:update({entity},1)
  
end

return function()
    
  local HC = {}
  local position = {}
  local collision = {}
  
  local system = require "classes/system/collisionHandleSystem"(position, collision, HC)
  local e = {}
  
  testItSeperatesCollidingEntities(system, e, position, collision, HC) 
  testItIgnoresNoneCollisionEntities(system, e, position, collision, HC)
  
end