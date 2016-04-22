return function()
  return function(name, requirements)
    local componentName = name
    local requires = requirements or {}
    return {  
      add = function (entity, value)      
        for _, component in ipairs(requires) do
          assert(component.has(entity), "The required component " .. component:name() .. " was not found")
        end          

        entity:addComponent(componentName, {
            
            value = value,
            remove = function()
              
            end,
            allowRemoveOtherComponent = function(self, name, component)
              for _, requiredComponent in ipairs(requires) do
                if requiredComponent.isA(name, component) then
                  return false
                end
              end              
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
      name = function()
        return componentName
      end,
    }
  end
end