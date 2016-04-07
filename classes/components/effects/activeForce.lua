 local componentName = "activeForce"
 return function(rulestate, force) 
  local name = "activeForce-" .. math.random()
  return {
    add = function (entity, forceStrength)
      assert(rulestate.has(entity) == true, "Only entities with RuleState can have active force")
      assert(force.has(entity) == true, "Only entities with Force can have active force")
      force.get(entity):addForce(name)
      
      local component = {
        remove = function(self)
          force.get(entity):removeByName(name)
        end,
        becomesActive = function()
          force.get(entity):setForce(name, forceStrength.x, forceStrength.y)
        end,
        becomesInactive = function()
          force.get(entity):setForce(name, 0, 0)
        end,        
        allowRemoveOtherComponent = function(self, name, component)
          return not rulestate.isA(name, component) and not force.isA(name, component)
        end
      }
      
      rulestate.get(entity):addEffect(name, component)
      entity:addComponent(componentName, component)
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end
  }
end