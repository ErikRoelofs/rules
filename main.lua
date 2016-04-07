-- collision
-- AI (movement, collision, etc)
-- rendering
-- inventory
-- states? (life, death, etc)
-- gravity
-- event system
-- proper testing framework
-- inheritance for components
-- level designer
-- active force
-- rulestate does not work.

makeEntity = require "classes/core/newentity"

ruleState = require "classes/components/rulestate"()
position = require "classes/components/collision/position"()
motion = require "classes/components/movement/motion"(position)
force = require "classes/components/movement/force"(motion)
drag = require "classes/components/movement/drag"(force)
activeForce = require "classes/components/effects/activeForce"(ruleState, force)


keyTriggerCondition = require "classes/components/triggers/key"(ruleState)
otherBlockTrigger = require "classes/components/triggers/otherblock"()

inputHandler = require "classes/core/inputhandler"()

HC = require "libraries/hc"

forceSystem = require "classes/system/forceSystem"(force, motion)
motionSystem = require "classes/system/motionSystem"(motion, position)
dragSystem = require "classes/system/dragSystem"(drag, force, motion)

function love.load()
  if arg[#arg] == "-debug" then debug = true else debug = false end
  if debug then require("mobdebug").start() end

  verify()
  
  entity = makeEntity()
  ruleState.add(entity)
  position.add(entity)
  motion.add(entity)
  force.add(entity)
  drag.add(entity, 0.2)
  activeForce.add(entity, {x = 60, y = 40})
  keyTriggerCondition.add(entity, "q", inputHandler)
  
end

function love.update(dt)
  if love.keyboard.isDown("q") then
    inputHandler:keyDown("q")
  else
    inputHandler:keyUp("q")
  end
  
  
  
  motionSystem:update({entity}, dt)
  forceSystem:update({entity}, dt)
  dragSystem:update({entity}, dt)
end

function love.draw()
  love.graphics.setColor(0,255,0,255)
  love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
  
  love.graphics.setColor(255,255,255,255)
  local x, y = position.get(entity):getPosition()
  love.graphics.rectangle("fill", x,y,50,50)
  
  local fx, fy = force.get(entity):getSumForce()
  love.graphics.print("force: " .. fx .. ", " .. fy, 300, 20)
  
  local mx, my = motion.get(entity):getMotion()
  love.graphics.print("motion: " .. mx .. ", " .. my, 300, 40)

  local px, py = position.get(entity):getPosition()
  love.graphics.print("position: " .. px .. ", " .. py, 300, 60)

  
end

function love.keypressed(key, unicode)
  
end

function verify()
  require "tests/core/newentity"()
  require "tests/core/inputhandler"()
  require "tests/components/rulestate"()
  require "tests/components/collision/position"()
  require "tests/components/collision/shape"()
  require "tests/components/collision/collision"()
  require "tests/components/movement/motion"()
  require "tests/components/movement/force"()
  require "tests/components/movement/drag"()
  require "tests/components/carryable"()
  require "tests/components/inventory"()
  require "tests/components/triggers/key"()
  require "tests/components/triggers/otherblock"()
  require "tests/components/effects/activeForce"()
  require "tests/system/motionSystem"()
  require "tests/system/forceSystem"()
  require "tests/system/dragSystem"()
  
end