return {
  add = function (entity)
    local active = false
    entity:addComponent( "ruleState", {
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
        allowRemoveOtherComponent = function(self, name)
          return true
        end
    })
  end,
  remove = function (entity)
    entity:removeComponent("ruleState")
  end,
  get = function (entity)
    return entity:component("ruleState")
  end
}