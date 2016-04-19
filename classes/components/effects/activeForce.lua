 local componentName = "activeForce"
 return function(switchboard, force)   
  return {  
    add = function (entity, switch, forceStrength)      
      assert(switchboard.has(entity) == true, "Only entities with switchboard can have active force")
      assert(force.has(entity) == true, "Only entities with Force can have active force")
      local name = "activeForce-" .. math.random()
      force.get(entity):addForce(name)
      if not switchboard.get(entity):hasSwitch(switch) then
        switchboard.get(entity):registerSwitch(switch)
      end
      
      local component = {
        name = name,
        remove = function(self)
          force.get(entity):removeByName(self.name)
          switchboard.get(entity):removeEffect(switch, self.name)          
        end,
        becomesActive = function(self)
          force.get(entity):setForce(self.name, forceStrength.x, forceStrength.y)
        end,
        becomesInactive = function(self)
          force.get(entity):setForce(self.name, 0, 0)
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