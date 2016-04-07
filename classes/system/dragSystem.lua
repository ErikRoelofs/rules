return function(drag, force, motion)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if drag.has(entity) then
          local fComp = force.get(entity)
          local mComp = motion.get(entity)
          local x, y = mComp:getMotion()
          local dragAmount = drag.get(entity):getDragAmount()
          if not fComp:hasForce("drag") then
            fComp:addForce("drag")
          end
          
          fComp:setForce("drag", -1 * x * dragAmount , -1 * y * dragAmount)          
        end
      end
    end
  }  
end