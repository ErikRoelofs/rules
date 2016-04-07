local componentName = "force"
return function(motion)
  return {  
    add = function (entity, forceName)
      assert(motion.has(entity) == true, "Force requires Motion")
      local forces = {}
      if not entity:hasComponent(componentName) then
        entity:addComponent(componentName, {
            remove = function()
              
            end,
            allowRemoveOtherComponent = function(self, name, component)
              return not motion.isA(name, component)
            end,
            setForce = function(self, name, x, y)
              assert(forces[name], "Unknown force name: " .. name )
              forces[name].x = x
              forces[name].y = y
            end,
            getForce = function(self, name)
              assert(forces[name], "Unknown force name: " .. name )
              return forces[name].x, forces[name].y
            end,
            hasForce = function(self, name)
              return forces[name] ~= nil
            end,
            addForce = function(self, name)
              assert(not forces[name], "Already registered force by name of " .. name)
              forces[name] = { x = 0, y = 0 }
            end,
            getSumForce = function(self)
              local x = 0
              local y = 0
              for k, force in pairs(forces) do
                if force.x == nil then
                  stop = true
                end
                x = x + force.x
                y = y + force.y
              end
              return x, y
            end,
            removeByName = function(self, name)
              assert(forces[name], "Cannot remove " .. name .. ", it is not a force type")
              forces[name] = nil
            end,
            updateForce = function(self, name, x, y)
              assert(forces[name], "Unknown force name: " .. name )
              forces[name].x = forces[name].x + x
              forces[name].y = forces[name].y + y
            end
        })
      end
      if forceName then
        entity:component(componentName):addForce(forceName)
      end
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