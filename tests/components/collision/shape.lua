local function testItRequiresAShape(shape, entity)
  
  assert(pcall(function() shape.add(entity) end) == false, "Should fail because no shape is given")
  
  shape.add(entity, shape.circle(50))
  assert(shape.has(entity) == true, "It should be there")

end

local function testItCanBeRemoved(shape, entity)
  shape.add(entity, shape.circle(50))
  shape.remove(entity)    
  assert(shape.has(entity) == false, "Should have been removed")
end

local function testTheCircleShapeCanBeRecovered(shape, entity)
  shape.add(entity, shape.circle(50))
  local circle = shape.get(entity):getShape()
  assert(circle.shape == "circle", "Type should be circle")
  assert(circle.radius == 50, "Radius should be 50")
end

local function testTheRectangleShapeCanBeRecovered(shape, entity)
  shape.add(entity, shape.rectangle(50, 60))
  local circle = shape.get(entity):getShape()
  assert(circle.shape == "rectangle", "Type should be rectangle")
  assert(circle.width == 50, "Width should be 50")
  assert(circle.height == 60, "Height should be 60")
end

local function testThePointShapeCanBeRecovered(shape, entity)
  shape.add(entity, shape.point())
  local circle = shape.get(entity):getShape()
  assert(circle.shape == "point", "Type should be point")  
end


return function()
  local hc = require "libraries/hc"
  local s = require "classes/components/collision/shape"(hc)
  local e = require "classes/core/newentity"
    
  testItCanBeRemoved(s, e())
  testItRequiresAShape(s, e())
  testTheCircleShapeCanBeRecovered(s, e())
  testTheRectangleShapeCanBeRecovered(s, e())
  testThePointShapeCanBeRecovered(s, e())
  
end