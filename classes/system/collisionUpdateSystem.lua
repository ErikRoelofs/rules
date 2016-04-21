return function(position, collision)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if position.has(entity) and collision.has(entity) then
          local x, y = position.get(entity):getPosition()
          collision.get(entity):getShape():moveTo(x, y)
        end
      end
    end
  }  
end