return function()
  
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