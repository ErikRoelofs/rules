
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
    local anon = "otherBlock-target-" .. math.random()
    source:addEntity("otherBlockEffect", {
        targetName = anon,
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
    
    target:addEntity(anon, {    
      remove = function() end,
      allowRemoveOtherEntity = function(self, name)
        return name ~= "ruleState"
      end
    })
    source:entity("ruleState"):addEffect("block", source:entity("otherBlockEffect"))
  end,

  remove = function (entityToTrigger, entityThatTriggers)
    local targetEntityName = entityThatTriggers:entity("otherBlockEffect").targetName
    entityToTrigger:removeEntity(targetEntityName)
    entityThatTriggers:removeEntity("otherBlockEffect")  
    
  end
}