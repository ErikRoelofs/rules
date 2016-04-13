 return function(switchboard) 
  return {
    add = function (entity, switch, trigger, inputHandler)
      if not switchboard.has(entity) then
        error("Only entities with switchboard can have KeyTrigger")
      end
      if not switchboard.get(entity):hasSwitch(switch) then
        switchboard.get(entity):registerSwitch(switch)
      end
      local key = trigger
      local targetComponent = entity
      local name = "trigger_" .. math.random()
      entity:addComponent("triggerKey", {
        getTriggerKey = function(self)
          return key
        end,
        resolve = function(self, event)
          if event == "keydown" then
            switchboard.get(targetComponent):setActive(switch)
          elseif event == "keyup" then
            switchboard.get(targetComponent):setInactive(switch)
          end
        end,
        remove = function(self)
          inputHandler:removeTriggerForKey(key, name)
        end,
        allowRemoveOtherComponent = function(self, name, component)
          return not switchboard.isA(name, component)
        end
      })
      inputHandler:addTriggerForKey(key, name, entity:component("triggerKey"))
    end,

    remove = function (entity)
      entity:removeComponent("triggerKey")
    end
  }
end