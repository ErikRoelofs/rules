return function() 
  return {
    triggers = {},
    keyDown = function(self, key)
      for k, trigger in pairs(self:getTriggersForKey(key)) do
         trigger:resolve("keydown")
      end
    end,
    keyUp = function(self, key)
      for k, trigger in pairs(self:getTriggersForKey(key)) do
         trigger:resolve("keyup")
      end
    end,
    addTriggerForKey = function(self, key, name, trigger)
      if self.triggers[key] == nil then
        self.triggers[key] = {}
      end
      self.triggers[key][name] = trigger
    end,
    removeTriggerForKey = function(self, key, name)
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