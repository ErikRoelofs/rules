return function(motion, position)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if motion.has(entity) then
          local x, y = motion.get(entity):getMotion()
          position.get(entity):movePosition(x * dt, y * dt)
        end
      end
    end
  }  
end