local componentName = "force"
return function(position)
  return {  
    add = function (entity, forceName)
      assert(position.has(entity) == true, "Motion requires Position")
      local forces = {}
      if not entity:hasComponent(componentName) then
        entity:addComponent(componentName, {
            remove = function()
              
            end,
            allowRemoveOtherComponent = function(self, name, component)
              return not position.isA(name, component)
            end,
            setMotion = function(self, name, x, y)
              assert(forces[name], "Unknown force name: " .. name )
              forces[name].x = x
              forces[name].y = y
            end,
            getMotion = function(self, name)
              assert(forces[name], "Unknown force name: " .. name )
              return forces[name].x, forces[name].y
            end,            
            addMotion = function(self, name)
              assert(not forces[name], "Already registered force by name of " .. name)
              forces[name] = { x = 0, y = 0 }
            end,
            getSumMotion = function(self)
              local x = 0
              local y = 0
              for k, force in pairs(forces) do
                x = x + force.x
                y = y + force.y
              end
              return x, y
            end,
            removeByName = function(self, name)
              assert(forces[name], "Cannot remove " .. name .. ", it is not a force type")
              forces[name] = nil
            end,
            update = function(self, dt)
              local x, y = self:getSumMotion()
              position.get(entity):movePosition(x * dt, y * dt)
            end
        })
      end
      entity:component(componentName):addMotion(forceName)
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