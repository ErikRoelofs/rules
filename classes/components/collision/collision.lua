local componentName = "collision"
return function(position, shape, hc)
  return {  
    add = function (entity)
      assert(position.has(entity), "Collision requires Position")
      assert(shape.has(entity), "Collision requires Shape")
      
      local entityShape = shape.get(entity):getShape()
      local posX, posY = position.get(entity):getPosition()
      local hcShape = nil
      if entityShape.shape == "circle" then
        hcShape = hc.circle(posX, posY, entityShape.radius)
      elseif entityShape.shape == "rectangle" then
        hcShape = hc.rectangle(posX, posY, entityShape.width, entityShape.height)
      elseif entityShape.shape == "point" then
        hcShape = hc.point(posX, posY)
      end
      
      entity:addComponent(componentName, {
          shape = hcShape,
          getShape = function(self)
            return self.shape
          end,
          remove = function(self)
            hc.remove(self.shape)
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not position.isA(name, component) and not shape.isA(name, component)
          end
      })
          
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end,
    get = function(entity)
      return entity:component(componentName)
    end,
    has = function(entity)
      return entity:hasComponent(componentName)
    end,
    isA = function (name, component)
      return name == componentName
    end    
  }
end