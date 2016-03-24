return {
  add = function (entity, trigger, inputHandler)
    if not entity:hasComponent("ruleState") then
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
          targetComponent:component("ruleState"):setActive()
        elseif event == "keyup" then
          targetComponent:component("ruleState"):setInactive()
        end
      end,
      remove = function(self)
        inputHandler:removeTriggerForKey(key, name)
      end,
      allowRemoveOtherComponent = function(self, name)
        return name ~= "ruleState"
      end
    })
    inputHandler:addTriggerForKey(key, name, entity:component("triggerKey"))
  end,

  remove = function (entity)
    entity:removeComponent("triggerKey")
  end
}