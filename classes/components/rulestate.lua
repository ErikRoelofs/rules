return {
  add = function (entity)
    local active = false
    entity:addEntity( "ruleState", {
        effects = {},
        addEffect = function(self, name, effect)
          self.effects[name] = effect
        end,
        removeEffect = function(self, name)
          self.effects[name] = nil
        end,
        setActive = function(self)
          if not active then
            active = true
            for name, effect in pairs(self.effects) do
              effect:becomesActive()
            end
          end
        end,
        setInactive = function(self)
          if active then
            active = false
            for name, effect in pairs(self.effects) do
              effect:becomesInactive()
            end
          end
        end,
        isActive = function(self)
          return active
        end,
        remove = function(self)
          
        end,
        allowRemoveOtherEntity = function(self, name)
          return true
        end
    })
  end,
  remove = function (entity)
    entity:removeEntity("ruleState")
  end
}