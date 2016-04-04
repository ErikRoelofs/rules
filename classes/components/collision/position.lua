local componentName = "position"
return function()
  return {  
    add = function (entity)
      local xPos = 0
      local yPos = 0
      entity:addComponent(componentName, {
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return true
          end,
          setPosition = function(self, x, y)
            xPos = x
            yPos = y
          end,
          getPosition = function(self, x, y)
            return xPos, yPos
          end,
          movePosition = function(self, x, y)
            xPos = xPos + x
            yPos = yPos + y
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
    
  }
end