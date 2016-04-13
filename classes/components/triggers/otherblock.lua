return function(switchboard)
  return {  
    add = function (entityThatTriggers, triggerSwitch, entityToTrigger, targetSwitch)
      if not switchboard.has(entityToTrigger) then
        error("Only entities with switchboard can be the ToTrigger")
      end
      if not switchboard.has(entityThatTriggers) then
        error("Only entities with switchboard can be the Trigger")
      end
      if not switchboard.get(entityThatTriggers):hasSwitch(triggerSwitch) then
        switchboard.get(entityThatTriggers):registerSwitch(triggerSwitch)
      end
      if not switchboard.get(entityToTrigger):hasSwitch(targetSwitch) then
        switchboard.get(entityToTrigger):registerSwitch(targetSwitch)
      end
      local target = entityToTrigger
      local source = entityThatTriggers    
      local anon = "otherBlock-target-" .. math.random()
      source:addComponent("otherBlockEffect", {
          targetName = anon,
          becomesActive = function()
            switchboard.get(target):setActive(targetSwitch)
          end,
          becomesInactive = function()
            switchboard.get(target):setInactive(targetSwitch)
          end,
          remove = function()
            switchboard.get(source):removeEffect(triggerSwitch, "block")
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not switchboard.isA(name, component)
          end
      })  
      
      target:addComponent(anon, {    
        remove = function() end,
        allowRemoveOtherComponent = function(self, name, component)
          return not switchboard.isA(name, component)
        end
      })
      switchboard.get(source):addEffect(triggerSwitch, "block", source:component("otherBlockEffect"))
    end,

    remove = function (entityToTrigger, entityThatTriggers)
      local targetComponentName = entityThatTriggers:component("otherBlockEffect").targetName
      entityToTrigger:removeComponent(targetComponentName)
      entityThatTriggers:removeComponent("otherBlockEffect")  
      
    end,
    get = function(entity)
      return entity:component("otherBlockEffect")
    end
  }
end