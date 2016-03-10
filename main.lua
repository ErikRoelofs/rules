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
    removeEntity = function(self, name)
      assert( self.entities[name], "Cannot remove " .. name .. ", it is not registered" )
      self:checkEntityCanBeRemoved(name)
      self.entities[name]:remove()
      self.entities[name] = nil
    end,
    checkEntityCanBeRemoved = function(self, name)
      for entityName, entity in pairs(self.entities) do
        if not entity:allowRemoveOtherEntity(name) then
          error("Cannot remove " .. name .. ", it is not allowed by " .. entityName)
        end
      end
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
      effects = {},
      addEffect = function(self, name, effect)
        self.effects[name] = effect
      end,
      removeEffect = function(self, name)
        self.effects[name] = nil
      end,
      setActive = function(self)
        if not active then
          active = true
          for name, effect in pairs(self.effects) do
            effect:becomesActive()
          end
        end
      end,
      setInactive = function(self)
        active = false
        for name, effect in pairs(self.effects) do
          effect:becomesInactive()
        end
      end,
      isActive = function(self)
        return active
      end,
      remove = function(self)
        
      end,
      allowRemoveOtherEntity = function(self, name)
        return true
      end
  })
end

function removeRuleState(entity)
  entity:removeEntity("ruleState")
end

function giveKeyTriggerCondition(entity, trigger, inputHandler)
  if not entity:hasEntity("ruleState") then
    error("Only entities with RuleState can have KeyTrigger")
  end
  local key = trigger
  local targetEntity = entity
  local name = "trigger_" .. math.random()
  entity:addEntity("triggerKey", {
    getTriggerKey = function(self)
      return key
    end,
    resolve = function(self, event)
      if event == "keydown" then
        targetEntity:entity("ruleState"):setActive()
      elseif event == "keyup" then
        targetEntity:entity("ruleState"):setInactive()
      end
    end,
    remove = function(self)
      inputHandler:removeTriggerForKey(key, name)
    end,
    allowRemoveOtherEntity = function(self, name)
      return name ~= "ruleState"
    end
  })
  inputHandler:addTriggerForKey(key, name, entity:entity("triggerKey"))
end

function removeKeyTrigger(entity)
  entity:removeEntity("triggerKey")
end

function giveOtherBlockTrigger(entityToTrigger, entityThatTriggers)
  if not entityToTrigger:hasEntity("ruleState") then
    error("Only entities with RuleState can be the ToTrigger")
  end
  if not entityThatTriggers:hasEntity("ruleState") then
    error("Only entities with RuleState can be the Trigger")
  end
  local target = entityToTrigger
  local source = entityThatTriggers
  
  source:addEntity("otherBlockEffect", {
      becomesActive = function()
        target:entity("ruleState"):setActive()
      end,
      becomesInactive = function()
        target:entity("ruleState"):setInactive()
      end,
      remove = function()
        source:entity("ruleState"):removeEffect("block")
      end,
      allowRemoveOtherEntity = function(self, name)
        return name ~= "ruleState"
      end
  })
  source:entity("ruleState"):addEffect("block", source:entity("otherBlockEffect"))
end

function removeOtherBlockTrigger(entityToTrigger, entityThatTriggers)  
  local source = entityThatTriggers
  source:removeEntity("otherBlockEffect")  
end

function givePrintEffect(entity, line, output)
  if not entity:hasEntity("ruleState") then
    error("Only entities with RuleState can have PrintEffect")
  end
  local lineToPrint = line
  local outputHandler = output
  entity:addEntity("printEffect", {
    becomesActive = function()
      outputHandler:printOut(lineToPrint)
    end,
    becomesInactive = function()
    end,
    allowRemoveOtherEntity = function(self, name)
      return name ~= "ruleState"
    end,
    remove = function(self)
      
    end
  })
  entity:entity("ruleState"):addEffect("print", entity:entity("printEffect"))
end

function removePrintEffect(entity)
  entity:removeEntity("printEffect")
end

inputHandler = {
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

outputHandler = {
  printOut = function(self, text)
    table.insert(self.lines, text)
  end,
  lines = {}
}

function love.load()
  if arg[#arg] == "-debug" then debug = true else debug = false end
  if debug then require("mobdebug").start() end

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
  block:entity("ruleState"):setActive()
  assert(block:entity("ruleState").isActive() == true, "Block should be active")
  block:entity("ruleState"):setInactive()
  assert(block:entity("ruleState").isActive() == false, "Block should be inactive")
  
  giveKeyTriggerCondition(block, "q", inputHandler)
  assert(block:entity("triggerKey").getTriggerKey() == "q", "Block should return its trigger key")

  assert(inputHandler:getNumTriggersForKey("q") == 1, "TriggerKey should have registered itself with inputHandler")

  inputHandler:keyDown("q")
  assert(block:entity("ruleState").isActive() == true, "Block should be active after receiving key down to its trigger")

  inputHandler:keyUp("q")
  assert(block:entity("ruleState").isActive() == false, "Block should be inactive after receiving key up to its trigger")

  local block2 = makeEntity()
  
  assert( pcall(function() givePrintEffect(block2) end) == false, "Block 2 should not be allowed print effect as it has no rulestate") 
  giveRuleState(block2)
  
  assert(block2:entity("ruleState").isActive() == false, "Block 2 should be inactive")

  local line = "hello world"
  givePrintEffect(block2, line, outputHandler)
  
  assert(#outputHandler.lines == 0, "There should be no output")
  
  block2:entity("ruleState"):setActive()
  
  assert(#outputHandler.lines == 1, "It should output a line")
  assert(outputHandler.lines[1] == line, "It should be the correct line (wanted: " .. line ..", but got: " .. outputHandler.lines[1] .. ")")
  
  block2:entity("ruleState"):setInactive()
  assert(block2:entity("ruleState").isActive() == false, "Block 2 should be inactive")
  
  giveOtherBlockTrigger(block2, block)
  assert(block:entity("otherBlockEffect"), "Block 1 should have an other-block effect")
  
  block:entity("ruleState"):setActive()
  assert(block2:entity("ruleState"):isActive() == true, "Block 2 should become active when Block 1 does.")
  assert(#outputHandler.lines == 2, "It should have output a line")
  
  block:entity("ruleState"):setInactive()
  assert(block2:entity("ruleState"):isActive() == false, "Block 2 should become inactive when Block 1 does.")
  
  inputHandler:keyDown("q")
  assert(#outputHandler.lines == 3, "Pressing Q should have output another line")
  
  inputHandler:keyDown("q")
  assert(#outputHandler.lines == 3, "Pressing Q while it is already active should NOT output another line")

  inputHandler:keyUp("q")
  assert(block2:entity("ruleState"):isActive() == false, "Block 2 should become inactive when Q is released")

  removeOtherBlockTrigger(block2, block)
  inputHandler:keyDown("q")
  inputHandler:keyUp("q")
  assert(#outputHandler.lines == 3, "Pressing Q should not output another line after removing the trigger")
  
  assert( pcall(function() removeOtherBlockTrigger(block2, block) end) == false, "It should not be possible to remove an entity that is not available" )

  removeKeyTrigger(block)
  inputHandler:keyDown("q")
  assert(block:entity("ruleState").isActive() == false, "Block should no longer be active when Q is pressed")

  removeRuleState(block)
  assert(block:hasEntity("ruleState") == false, "Block should no longer have ruleState" )

  assert( pcall( function() removeRuleState(block2) end ) == false, "Should not be possible to remove ruleState if a block still has a printEffect" )
  
  removePrintEffect(block2)
  assert(block:hasEntity("printEffect") == false, "Block should no longer have print effect" )
  
  removeRuleState(block2)
  assert(block:hasEntity("ruleState") == false, "Block should no longer have ruleState" )

end