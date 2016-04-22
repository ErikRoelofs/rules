return function(position, collision, hc)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if collision.has(entity) then
          for bump, vector in pairs(hc.collisions(collision.get(entity):getShape())) do
            position.get(entity):movePosition(vector.x, vector.y)
          end
        end
      end
    end
  }  
end