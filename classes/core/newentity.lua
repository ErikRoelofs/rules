return function()
  local entity = {
    component = function(self, name)
      if self.components[name] == nil then
        error("Trying to recover an unregistered component")
      end
      return self.components[name]
    end,
    addComponent = function(self, name, component)
      assert(self.components[name] == nil, "An component with this name is already registered." )
      self.components[name] = component
    end,
    removeComponent = function(self, name)
      assert( self.components[name], "Cannot remove " .. name .. ", it is not registered" )
      self:checkComponentCanBeRemoved(name)
      self.components[name]:remove()
      self.components[name] = nil
    end,
    checkComponentCanBeRemoved = function(self, name)
      for componentName, component in pairs(self.components) do
        if not component:allowRemoveOtherComponent(name) then
          error("Cannot remove " .. name .. ", it is not allowed by " .. componentName)
        end
      end
    end,
    hasComponent = function(self, name)
      return self.components[name] ~= nil
    end,
    components = {},
  }
  return entity
end