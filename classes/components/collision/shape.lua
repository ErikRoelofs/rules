local componentName = "shape"
return function()
  return {  
    add = function (entity, shape)
      assert(shape, "A shape is required")      
      entity:addComponent(componentName, {        
          shape = shape,
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return true
          end,
          getShape = function(self)
            return self.shape
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
    end,
    circle = function(radius)
      return {
        shape = "circle",
        radius = radius
      }
    end,
    rectangle = function(width, height)
      return {
        shape = "rectangle",
        width = width,
        height = height
      }
    end,
    point = function()
      return {
        shape = "point"
      }
    end
  }
end