local componentName = "activeDrag"
 return function(switchboard, drag)   
  return {  
    add = function (entity, switch, dragStrength)      
      assert(switchboard.has(entity) == true, "Only entities with switchboard can have active drag")
      assert(drag.has(entity) == true, "Only entities with Drag can have active drag")      
      
      if not switchboard.get(entity):hasSwitch(switch) then
        switchboard.get(entity):registerSwitch(switch)
      end
      
      local component = {
        activeDrag = dragStrength,
        inactiveDrag = drag.get(entity):getDragAmount(),
        remove = function(self)
          drag.get(entity):setDragAmount(self.inactiveDrag)
          switchboard.get(entity):removeEffect(switch, "activeDrag")
        end,
        becomesActive = function(self, name)
          drag.get(entity):setDragAmount(self.activeDrag)
        end,
        becomesInactive = function(self, name)
          drag.get(entity):setDragAmount(self.inactiveDrag)
        end,        
        allowRemoveOtherComponent = function(self, name, component)
          return not switchboard.isA(name, component) and not drag.isA(name, component)
        end
      }
      entity:addComponent(componentName, component)      
      switchboard.get(entity):addEffect(switch, "activeDrag", component)      
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end
  }
end