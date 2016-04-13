 local componentName = "activeForce"
 return function(switchboard, force) 
  local name = "activeForce-" .. math.random()
  return {
    add = function (entity, switch, forceStrength)      
      assert(switchboard.has(entity) == true, "Only entities with switchboard can have active force")
      assert(force.has(entity) == true, "Only entities with Force can have active force")
      force.get(entity):addForce(name)
      if not switchboard.get(entity):hasSwitch(switch) then
        switchboard.get(entity):registerSwitch(switch)
      end
      
      local component = {
        remove = function(self)
          force.get(entity):removeByName(name)
          switchboard.get(entity):removeEffect(switch, name)          
        end,
        becomesActive = function()
          force.get(entity):setForce(name, forceStrength.x, forceStrength.y)
        end,
        becomesInactive = function()
          force.get(entity):setForce(name, 0, 0)
        end,        
        allowRemoveOtherComponent = function(self, name, component)
          return not switchboard.isA(name, component) and not force.isA(name, component)
        end
      }
      
      switchboard.get(entity):addEffect(switch, name, component)
      entity:addComponent(componentName, component)
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end
  }
end