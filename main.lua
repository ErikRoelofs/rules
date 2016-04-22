-- collision
  -- gravity
  -- AI (movement, collision, etc)
-- jumping (keyOnce trigger)
-- rendering
-- inventory
-- states? (life, death, etc)
-- event system
-- proper testing framework
-- inheritance for components
-- level designer
-- dependency injection
-- quick add
-- forces should use trigonometry

-- attacks
-- keys/doors
-- level transitions
-- stories
-- gui
-- menu

makeEntity = require "classes/core/newentity"

switchboard = require "classes/components/switchboard"()
position = require "classes/components/collision/position"()
shape = require "classes/components/collision/shape"()
motion = require "classes/components/movement/motion"(position)
force = require "classes/components/movement/force"(motion)
drag = require "classes/components/movement/drag"(force)
activeForce = require "classes/components/effects/activeForce"(switchboard, force)
activeDrag = require "classes/components/effects/activeDrag"(switchboard, drag)

keyTriggerCondition = require "classes/components/triggers/key"(switchboard)
otherBlockTrigger = require "classes/components/triggers/otherblock"()

inputHandler = require "classes/core/inputhandler"()

HC = require "libraries/hc"
collision = require "classes/components/collision/collision"(position, shape, HC)

forceSystem = require "classes/system/forceSystem"(force, motion)
motionSystem = require "classes/system/motionSystem"(motion, position)
dragSystem = require "classes/system/dragSystem"(drag, force, motion)
collisionUpdateSystem = require "classes/system/collisionUpdateSystem"(position, collision)

function love.load()
  if arg[#arg] == "-debug" then debug = true else debug = false end
  if debug then require("mobdebug").start() end

  verify()
  
  entity = makeEntity()
  switchboard.add(entity)
  position.add(entity)
  position.get(entity):setPosition(75,75)
  motion.add(entity)
  force.add(entity)
  drag.add(entity, 10)
  shape.add(entity, shape.rectangle(50, 50))
  collision.add(entity)
  
  activeForce.add(entity, "move-left", {x = 1000, y = 0})
  keyTriggerCondition.add(entity, "move-left", "q", inputHandler)
    
  activeForce.add(entity, "move-back", {x = -1000, y = -0})
  keyTriggerCondition.add(entity, "move-back", "w", inputHandler)

  activeDrag.add(entity, "brake", 4)
  keyTriggerCondition.add(entity, "brake", "e", inputHandler)

  wall = makeEntity()
  position.add(wall)
  position.get(wall):setPosition(175,25)
  shape.add(wall, shape.rectangle(50,200))
  collision.add(wall)
  
end

function love.update(dt)
  motionSystem:update({entity}, dt)
  forceSystem:update({entity}, dt)
  dragSystem:update({entity}, dt)
  collisionUpdateSystem:update({entity}, dt)
  
end

function love.keypressed(key, code, isRepeat)
  inputHandler:keyDown(key)
end

function love.keyreleased(key)
  inputHandler:keyUp(key)
end

function love.draw()
  love.graphics.setColor(0,255,0,255)
  love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
  
  love.graphics.setColor(255,255,255,255)
  local x, y = position.get(entity):getPosition()
  love.graphics.rectangle("fill", x-25,y-25,50,50)
    
  local x, y = position.get(wall):getPosition()
  love.graphics.rectangle("fill", x,y,50,200)
  collision.get(wall):getShape():draw("line")
  
  local fx, fy = force.get(entity):getSumForce()
  love.graphics.print("force: " .. fx .. ", " .. fy, 300, 20)
  
  local mx, my = motion.get(entity):getMotion()
  love.graphics.print("motion: " .. mx .. ", " .. my, 300, 40)

  local px, py = position.get(entity):getPosition()
  love.graphics.print("position: " .. px .. ", " .. py, 300, 60)
  
  collision.get(entity):getShape():draw("line")
  
  for shape, delta in pairs(HC.collisions(collision.get(entity):getShape())) do
    love.graphics.print(string.format("Colliding. Separating vector = (%s,%s)",
                                      delta.x, delta.y), 300, 500)
  end

end

function verify()
  require "tests/core/newentity"()
  require "tests/core/inputhandler"()  
  require "tests/components/switchboard"()
  require "tests/components/simple"()
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
  require "tests/components/effects/activeDrag"()
  require "tests/system/motionSystem"()
  require "tests/system/forceSystem"()
  require "tests/system/dragSystem"()
  require "tests/system/collisionUpdateSystem"()
  
end