return function()
  return function(name)
    local componentName = name
    return {  
      add = function (entity, value)      
        entity:addComponent(componentName, {
            value = value,
            remove = function()
              
            end,
            allowRemoveOtherComponent = function(self, name, component)
              return true
            end,
            setValue = function(self, value)
              self.value = value
            end,
            getValue = function(self)
              return self.value
            end,       
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
end