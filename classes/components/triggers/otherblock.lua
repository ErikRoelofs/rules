
return {  
  add = function (entityToTrigger, entityThatTriggers)
    if not entityToTrigger:hasComponent("ruleState") then
      error("Only entities with RuleState can be the ToTrigger")
    end
    if not entityThatTriggers:hasComponent("ruleState") then
      error("Only entities with RuleState can be the Trigger")
    end
    local target = entityToTrigger
    local source = entityThatTriggers    
    local anon = "otherBlock-target-" .. math.random()
    source:addComponent("otherBlockEffect", {
        targetName = anon,
        becomesActive = function()
          target:component("ruleState"):setActive()
        end,
        becomesInactive = function()
          target:component("ruleState"):setInactive()
        end,
        remove = function()
          source:component("ruleState"):removeEffect("block")
        end,
        allowRemoveOtherComponent = function(self, name)
          return name ~= "ruleState"
        end
    })  
    
    target:addComponent(anon, {    
      remove = function() end,
      allowRemoveOtherComponent = function(self, name)
        return name ~= "ruleState"
      end
    })
    source:component("ruleState"):addEffect("block", source:component("otherBlockEffect"))
  end,

  remove = function (entityToTrigger, entityThatTriggers)
    local targetComponentName = entityThatTriggers:component("otherBlockEffect").targetName
    entityToTrigger:removeComponent(targetComponentName)
    entityThatTriggers:removeComponent("otherBlockEffect")  
    
  end
}