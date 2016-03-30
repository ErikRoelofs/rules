return function(rulestate)
  return {  
    add = function (entityToTrigger, entityThatTriggers)
      if not rulestate.has(entityToTrigger) then
        error("Only entities with RuleState can be the ToTrigger")
      end
      if not rulestate.has(entityThatTriggers) then
        error("Only entities with RuleState can be the Trigger")
      end
      local target = entityToTrigger
      local source = entityThatTriggers    
      local anon = "otherBlock-target-" .. math.random()
      source:addComponent("otherBlockEffect", {
          targetName = anon,
          becomesActive = function()
            rulestate.get(target):setActive()
          end,
          becomesInactive = function()
            rulestate.get(target):setInactive()
          end,
          remove = function()
            rulestate.get(source):removeEffect("block")
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not rulestate.isA(name, component)
          end
      })  
      
      target:addComponent(anon, {    
        remove = function() end,
        allowRemoveOtherComponent = function(self, name, component)
          return not rulestate.isA(name, component)
        end
      })
      rulestate.get(source):addEffect("block", source:component("otherBlockEffect"))
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