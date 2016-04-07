return function(force, dragAmount)
  return {
    update = function(self, entities, dt)
      for _, entity in ipairs(entities) do
        if force.has(entity) then
          local fComp = force.get(entity)
          local x, y = fComp:getSumForce()
          if not fComp:hasForce("drag") then
            fComp:addForce("drag")
          end
                    
          fComp:updateForce("drag", -1 * math.min(dragAmount * dt, x) , 0)
          fComp:updateForce("drag", 0, -1 * math.min(dragAmount * dt, y))
          
        end
      end
    end
  }  
end