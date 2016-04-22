 local componentName = "collision"
 return function(switchboard) 
  return {
    add = function (entity, switch, checkComponents)
      if not switchboard.has(entity) then
        error("Only entities with switchboard can have CollisionTrigger")
      end
      if not switchboard.get(entity):hasSwitch(switch) then
        switchboard.get(entity):registerSwitch(switch)
      end      
      
      local name = "collisiontrigger_" .. math.random()
      if not entity:hasComponent(componentName) then        
        entity:addComponent(componentName, {
          map = {},
          target = entity,
          addTrigger = function(self, switch, checkComponents)
            table.insert(self.map, { switch = switch, name = name, components = checkComponents })            
          end,
          resolve = function(self, entity, vector)            
            for _, map in ipairs(self.map) do
              local set = true
              for _, toCheck in ipairs(map.components) do
                if not toCheck.has(entity) then
                  set = false
                end
              end
              if set then
                switchboard.get(self.target):setActive(map.switch)
              end
            end
          end,
          remove = function(self)
            for _, map in ipairs(self.map) do
              
            end          
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not switchboard.isA(name, component)
          end
        })
      end
      
      entity:component(componentName):addTrigger(switch, checkComponents)
      
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end,
    get = function(entity)
      return entity:component(componentName)
    end
  }
end