return {
  add = function (entityToTrigger, entityThatTriggers)
    if not entityToTrigger:hasEntity("ruleState") then
      error("Only entities with RuleState can be the ToTrigger")
    end
    if not entityThatTriggers:hasEntity("ruleState") then
      error("Only entities with RuleState can be the Trigger")
    end
    local target = entityToTrigger
    local source = entityThatTriggers
    
    source:addEntity("otherBlockEffect", {
        becomesActive = function()
          target:entity("ruleState"):setActive()
        end,
        becomesInactive = function()
          target:entity("ruleState"):setInactive()
        end,
        remove = function()
          source:entity("ruleState"):removeEffect("block")
        end,
        allowRemoveOtherEntity = function(self, name)
          return name ~= "ruleState"
        end
    })
    source:entity("ruleState"):addEffect("block", source:entity("otherBlockEffect"))
  end,

  remove = function (entityToTrigger, entityThatTriggers)      
    entityThatTriggers:removeEntity("otherBlockEffect")  
  end
}