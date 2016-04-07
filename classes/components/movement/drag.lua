local componentName = "drag"
return function(force)
  return {  
    add = function (entity, dragAmount)
      assert(force.has(entity) == true, "Drag requires Force")
      assert(type(dragAmount) == "number", "Drag amount should be set")
      local drag = dragAmount
      entity:addComponent(componentName, {
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not force.isA(name, component)
          end,
          setDragAmount = function(self, dragAmount)            
            drag = dragAmount
          end,
          getDragAmount = function(self)
            return drag
          end,       
          addDragAmount = function(self, amount)
            drag = drag + amount            
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