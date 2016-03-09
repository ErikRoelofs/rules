function makeEntity()
  local block = {
    entity = function(self, name)
      if self.entities[name] == nil then
        error("Trying to recover an unregistered entity")
      end
      return self.entities[name]
    end,
    addEntity = function(self, name, entity)
      self.entities[name] = entity
    end,
    hasEntity = function(self, name)
      return self.entities[name] ~= nil
    end,
    entities = {},
  }
  return block
end

function giveRuleState(entity)
  local active = false
  entity:addEntity( "ruleState", {
      setActive = function()
        active = true
      end,
      setInactive = function()
        active = false
      end,
      isActive = function()
        return active
      end
  })
end

function giveKeyTriggerCondition(entity, trigger)
  if not entity:hasEntity("ruleState") then
    error("Only entities with RuleState can have KeyTrigger")
  end
  local key = trigger
  local targetEntity = entity
  entity:addEntity("triggerKey", {
    getTriggerKey = function(self)
      return key
    end,
    resolve = function(self, event)
      if event == "keydown" then
        targetEntity:entity("ruleState").setActive()
      elseif event == "keyup" then
        targetEntity:entity("ruleState").setInactive()
      end
    end
  })
  inputHandler:addTriggerForKey(key, entity:entity("triggerKey"))
end

inputHandler = {
  triggers = {},
  keyDown = function(self, key)
    for k, trigger in ipairs(self:getTriggersForKey(key)) do
       trigger:resolve("keydown")
    end
  end,
  keyUp = function(self, key)
    for k, trigger in ipairs(self:getTriggersForKey(key)) do
       trigger:resolve("keyup")
    end
  end,
  addTriggerForKey = function(self, key, trigger)
    if self.triggers[key] == nil then
      self.triggers[key] = {}
    end
    table.insert(self.triggers[key], trigger)
  end,
  getTriggersForKey = function(self, key)
    if self.triggers[key] == nil then
      return {}
    end
    return self.triggers[key]
  end
}

function love.load()
  
  verify()
  
  
end

function love.update(dt)
  
end

function love.draw()
  
end

function love.keypressed(key, unicode)
  press = 1
end

function verify()
  
  local block = makeEntity()  

  assert( pcall(function() giveKeyTriggerCondition(block) end) == false, "Block should not be allowed keytrigger as it has no rulestate") 
  assert( pcall(function() block:entity("ruleState") end) == false, "Block should throw error for not having a rulestate entity")
    
  giveRuleState(block)
  
  assert(block:entity("ruleState").isActive() == false, "Block should be inactive")
  block:entity("ruleState").setActive()
  assert(block:entity("ruleState").isActive() == true, "Block should be active")
  block:entity("ruleState").setInactive()
  assert(block:entity("ruleState").isActive() == false, "Block should be inactive")
  
  giveKeyTriggerCondition(block, "q")
  assert(block:entity("triggerKey").getTriggerKey() == "q", "Block should return its trigger key")

  assert(#inputHandler:getTriggersForKey("q") == 1, "TriggerKey should have registered itself with inputHandler")

  inputHandler:keyDown("q")
  assert(block:entity("ruleState").isActive() == true, "Block should be active after receiving key down to its trigger")

  inputHandler:keyUp("q")
  assert(block:entity("ruleState").isActive() == false, "Block should be inactive after receiving key up to its trigger")


end