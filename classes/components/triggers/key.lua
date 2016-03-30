 return function(rulestate) 
  return {
    add = function (entity, trigger, inputHandler)
      if not rulestate.has(entity) then
        error("Only entities with RuleState can have KeyTrigger")
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
            rulestate.get(targetComponent):setActive()
          elseif event == "keyup" then
            rulestate.get(targetComponent):setInactive()
          end
        end,
        remove = function(self)
          inputHandler:removeTriggerForKey(key, name)
        end,
        allowRemoveOtherComponent = function(self, name, component)
          return not rulestate.isA(name, component)
        end
      })
      inputHandler:addTriggerForKey(key, name, entity:component("triggerKey"))
    end,

    remove = function (entity)
      entity:removeComponent("triggerKey")
    end
  }
end