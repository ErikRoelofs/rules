local function testItRequiresShapeAndPosition(collision, shape, position, entity, hc)
  assert(pcall(function() collision.add(entity) end) == false, "It should require position/shape")
  position.add(entity)
  assert(pcall(function() collision.add(entity) end) == false, "It should require position/shape")
  shape.add(entity, shape.point())
  collision.add(entity)
  
  hc._reset()
end

local function testItCanBeRemoved(collision, shape, position, entity, hc)
  position.add(entity)
  shape.add(entity, shape.point())
  collision.add(entity)
  collision.remove(entity)
  assert(collision.has(entity) == false, "It should have been removed")
  
  hc._reset()
end

local function testItRegistersTheCircle(collision, shape, position, entity, hc)
  position.add(entity)
  shape.add(entity, shape.circle(50))
  collision.add(entity)
  assert(hc._count() == 1, "It should have been registered")
  
  hc._reset()
end

local function testItRegistersTheRectangle(collision, shape, position, entity, hc)
  position.add(entity)
  shape.add(entity, shape.rectangle(50,60))
  collision.add(entity)
  assert(hc._count() == 1, "It should have been registered")
  
  hc._reset()
end

local function testItRegistersThePoint(collision, shape, position, entity, hc)
  position.add(entity)
  shape.add(entity, shape.point())
  collision.add(entity)
  assert(hc._count() == 1, "It should have been registered")
  
  hc._reset()
end

local function testItUnregistersTheShapes(collision, shape, position, entity, hc)
  position.add(entity)
  shape.add(entity, shape.point())
  collision.add(entity)
  collision.remove(entity)
  
  assert(hc._count() == 0, "It should have been removed")
  
  hc._reset()
end


return function()
  function hc()
    local hits = 0
    local hc = {    
      circle = function()
        hits = hits + 1
      end,
      rectangle = function()
        hits = hits + 1
      end,
      point = function()
        hits = hits + 1
      end,
      remove = function()
        hits = hits - 1
      end,
      _reset = function()
        hits = 0
      end,
      _count = function()
        return hits
      end
    }
    return hc
  end
  local mockHc = hc()
  
  local p = require "classes/components/collision/position"()
  local s = require "classes/components/collision/shape"()
  local c = require "classes/components/collision/collision"(p, s, mockHc)
  local e = require "classes/core/newentity"
    
  testItCanBeRemoved(c, s, p, e(), mockHc)
  testItRequiresShapeAndPosition(c, s, p, e(), mockHc)
  testItRegistersTheCircle(c, s, p, e(), mockHc)
  testItRegistersTheRectangle(c, s, p, e(), mockHc)
  testItRegistersThePoint(c, s, p, e(), mockHc)
  testItUnregistersTheShapes(c, s, p, e(), mockHc)
end