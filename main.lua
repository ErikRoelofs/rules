-- movement
-- collision
-- AI (movement, collision, etc)
-- rendering
-- inventory
-- states? (life, death, etc)

makeEntity = require "classes/core/newentity"

ruleState = require "classes/components/rulestate"

keyTriggerCondition = require "classes/components/triggers/key"

otherBlockTrigger = require "classes/components/triggers/otherblock"

inputHandler = require "classes/core/inputhandler"()

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
  require "tests/components/movement/position"()
  require "tests/components/movement/motion"()
  require "tests/components/movement/force"()
  require "tests/components/carryable"()
  require "tests/components/inventory"()
  require "tests/components/triggers/key"()
  require "tests/components/triggers/otherblock"()
  require "tests/system/motionSystem"()
  
end