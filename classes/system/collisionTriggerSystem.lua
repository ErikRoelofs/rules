return function(collision, hc)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if collision.has(entity) then          
          collision.get(entity):reset()
          for bump, vector in pairs(hc.collisions(collision.get(entity):getShape())) do
            collision.get(entity):resolve(bump, vector)
          end
        end
      end
    end
  }  
end