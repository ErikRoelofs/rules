return function()
  local block = {
    entity = function(self, name)
      if self.entities[name] == nil then
        error("Trying to recover an unregistered entity")
      end
      return self.entities[name]
    end,
    addEntity = function(self, name, entity)
      assert(self.entities[name] == nil, "An entity with this name is already registered." )
      self.entities[name] = entity
    end,
    removeEntity = function(self, name)
      assert( self.entities[name], "Cannot remove " .. name .. ", it is not registered" )
      self:checkEntityCanBeRemoved(name)
      self.entities[name]:remove()
      self.entities[name] = nil
    end,
    checkEntityCanBeRemoved = function(self, name)
      for entityName, entity in pairs(self.entities) do
        if not entity:allowRemoveOtherEntity(name) then
          error("Cannot remove " .. name .. ", it is not allowed by " .. entityName)
        end
      end
    end,
    hasEntity = function(self, name)
      return self.entities[name] ~= nil
    end,
    entities = {},
  }
  return block
end