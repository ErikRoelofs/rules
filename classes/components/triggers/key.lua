 local componentName = "triggerKey"
 return function(switchboard) 
  return {
    add = function (entity, switch, trigger, inputHandler)
      if not switchboard.has(entity) then
        error("Only entities with switchboard can have KeyTrigger")
      end
      if not switchboard.get(entity):hasSwitch(switch) then
        switchboard.get(entity):registerSwitch(switch)
      end
      local key = trigger
      local targetComponent = entity
      local name = "trigger_" .. math.random()
      if not entity:hasComponent(componentName) then        
        entity:addComponent(componentName, {
          map = {},
          getTriggerKey = function(self)
            return key
          end,
          addTrigger = function(self, key, switch)
            table.insert(self.map, { key = key, switch = switch, name = name })
            inputHandler:addTriggerForKey(key, name, entity:component(componentName))
          end,
          resolve = function(self, event, key)            
            for _, map in ipairs(self.map) do
              if map.key == key then
                if event == "keydown" then
                  switchboard.get(targetComponent):setActive(map.switch)
                elseif event == "keyup" then
                  switchboard.get(targetComponent):setInactive(map.switch)
                end                
              end
            end
          end,
          remove = function(self)
            for _, map in ipairs(self.map) do
              inputHandler:removeTriggerForKey(map.key, map.name)  
            end          
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not switchboard.isA(name, component)
          end
        })
      end
      
      entity:component(componentName):addTrigger(key, switch)
      
    end,

    remove = function (entity)
      entity:removeComponent("triggerKey")
    end
  }
end