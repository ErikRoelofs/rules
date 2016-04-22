local base = require "classes/components/simple"()
local componentName = "drag"
return function(force)
  local make = base(componentName, {force})
  make.add = function (entity, dragAmount)
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
    end
    return make
end