return function() 
  return {
    triggers = {},
    keyDown = function(self, key)
      for k, trigger in pairs(self:getTriggersForKey(key)) do
         trigger:resolve("keydown", key)
      end
    end,
    keyUp = function(self, key)
      for k, trigger in pairs(self:getTriggersForKey(key)) do
         trigger:resolve("keyup", key)
      end
    end,
    addTriggerForKey = function(self, key, name, trigger)
      if self.triggers[key] == nil then
        self.triggers[key] = {}
      end
      assert(self.triggers[key][name] == nil, "A trigger named " .. name .. " already exists for key " .. key )
      self.triggers[key][name] = trigger
    end,
    removeTriggerForKey = function(self, key, name)
      assert(self.triggers[key], "No triggers are registered for key " .. key )
      assert(self.triggers[key][name], "A trigger named " .. name .. " is not registered for key " .. key )
      self.triggers[key][name] = nil
    end,
    getTriggersForKey = function(self, key)
      if self.triggers[key] == nil then
        return {}
      end
      return self.triggers[key]
    end,
    getNumTriggersForKey = function(self, key)
      local num = 0
      for k, v in pairs(self:getTriggersForKey(key)) do
        num = num+1
      end
      return num
    end
  }
end