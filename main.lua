makeEntity = require "classes/core/newentity"

ruleState = require "classes/components/rulestate"
giveRuleState = ruleState.add
removeRuleState = ruleState.remove

keyTriggerCondition = require "classes/components/triggers/key"
giveKeyTriggerCondition = keyTriggerCondition.add
removeKeyTrigger = keyTriggerCondition.remove

otherBlockTrigger = require "classes/components/triggers/otherblock"
giveOtherBlockTrigger = otherBlockTrigger.add
removeOtherBlockTrigger = otherBlockTrigger.remove

printEffect = require "classes/components/effects/print"
givePrintEffect = printEffect.add
removePrintEffect = printEffect.remove

inputHandler = require "classes/core/inputhandler"()
outputHandler = require "classes/core/outputhandler"()

function love.load()
  if arg[#arg] == "-debug" then debug = true else debug = false end
  if debug then require("mobdebug").start() end

  verify()
  
end

function love.update(dt)
  
end

function love.draw()
  love.graphics.setColor(0,255,0,255)
  love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
end

function love.keypressed(key, unicode)
  press = 1
end

function verify()
  require "tests/core/newentity"()
  require "tests/core/inputhandler"()
  require "tests/components/rulestate"()
  require "tests/components/triggers/key"()
  require "tests/components/triggers/otherblock"()
  
  require "tests/initial"()
  
end