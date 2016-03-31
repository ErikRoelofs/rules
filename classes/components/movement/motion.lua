local componentName = "motion"
return function(position)
  return {  
    add = function (entity, motionName)
      assert(position.has(entity) == true, "Motion requires Position")
      local motion = {x=0, y=0}      
      entity:addComponent(componentName, {
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return not position.isA(name, component)
          end,
          setMotion = function(self, x, y)            
            motion.x = x
            motion.y = y
          end,
          getMotion = function(self)
            return motion.x, motion.y
          end,       
          addMotion = function(self, x, y)
            motion.x = motion.x + x
            motion.y = motion.y + y
          end
      })
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