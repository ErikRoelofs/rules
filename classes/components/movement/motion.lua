local componentName = "motion"
return function(position)
  return {  
    add = function (entity, motionName)
      assert(position.has(entity) == true, "Motion requires Position")
      local motions = {}
      if not entity:hasComponent(componentName) then
        entity:addComponent(componentName, {
            remove = function()
              
            end,
            allowRemoveOtherComponent = function(self, name, component)
              return not position.isA(name, component)
            end,
            setMotion = function(self, name, x, y)
              assert(motions[name], "Unknown motion name: " .. name )
              motions[name].x = x
              motions[name].y = y
            end,
            getMotion = function(self, name)
              assert(motions[name], "Unknown motion name: " .. name )
              return motions[name].x, motions[name].y
            end,            
            addMotion = function(self, name)
              assert(not motions[name], "Already registered motion by name of " .. name)
              motions[name] = { x = 0, y = 0 }
            end,
            getSumMotion = function(self)
              local x = 0
              local y = 0
              for k, motion in pairs(motions) do
                x = x + motion.x
                y = y + motion.y
              end
              return x, y
            end,
            removeByName = function(self, name)
              assert(motions[name], "Cannot remove " .. name .. ", it is not a motion type")
              motions[name] = nil
            end
        })
      end
      entity:component(componentName):addMotion(motionName)
    end,
    remove = function (entity)      
      entity:removeComponent(componentName)
    end,
    get = function(entity)
      return entity:component(componentName)
    end,
    has = function(entity)
      return entity:hasComponent(componentName)
    end,
    isA = function (name, component)
      return name == componentName
    end,

  }
end