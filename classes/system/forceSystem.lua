return function(force, motion)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if force.has(entity) then
          local x, y = force.get(entity):getSumForce()
          motion.get(entity):addMotion(x, y)
        end
      end
    end
  }  
end