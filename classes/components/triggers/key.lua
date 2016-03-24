return {
  add = function (entity, trigger, inputHandler)
    if not entity:hasEntity("ruleState") then
      error("Only entities with RuleState can have KeyTrigger")
    end
    local key = trigger
    local targetEntity = entity
    local name = "trigger_" .. math.random()
    entity:addEntity("triggerKey", {
      getTriggerKey = function(self)
        return key
      end,
      resolve = function(self, event)
        if event == "keydown" then
          targetEntity:entity("ruleState"):setActive()
        elseif event == "keyup" then
          targetEntity:entity("ruleState"):setInactive()
        end
      end,
      remove = function(self)
        inputHandler:removeTriggerForKey(key, name)
      end,
      allowRemoveOtherEntity = function(self, name)
        return name ~= "ruleState"
      end
    })
    inputHandler:addTriggerForKey(key, name, entity:entity("triggerKey"))
  end,

  remove = function (entity)
    entity:removeEntity("triggerKey")
  end
}