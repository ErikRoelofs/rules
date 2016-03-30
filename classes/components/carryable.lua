local componentName = "carryable"
return function()
  return {  
    add = function (entity)
      entity:addComponent(componentName, {
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return true
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
  }
end