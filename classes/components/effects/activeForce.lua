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
      if not entity:hasComponent(componentName) then
        local component = {
          map = {},          
          remove = function(self)
            for _, map in ipairs(self.map) do
              force.get(entity):removeByName(map.name)
              switchboard.get(entity):removeEffect(map.switch, map.name)                        
            end
          end,
          addForce = function(self, name, switch, forceStrength)
            switchboard.get(entity):addEffect(switch, name, self)
            table.insert(self.map, {switch = switch, name = name, forceStrength = forceStrength } )
          end,
          becomesActive = function(self, name)
            for _, map in ipairs(self.map) do
              if map.switch == name then
                force.get(entity):setForce(map.name, map.forceStrength.x, map.forceStrength.y)  
              end
            end            
          end,
          becomesInactive = function(self, name)
            for _, map in ipairs(self.map) do
              if map.switch == name then
                force.get(entity):setForce(map.name, 0, 0)  
              end
            end            
          end,        
          allowRemoveOtherComponent = function(self, name, component)
            return not switchboard.isA(name, component) and not force.isA(name, component)
          end
        }
        entity:addComponent(componentName, component)
      end
      
      switchboard.get(entity):addEffect(switch, name, component)
      entity:component(componentName):addForce(name, switch, forceStrength)
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end
  }
end