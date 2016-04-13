local componentName = "switchboard"
return function() 
  return {
    add = function (entity)
      entity:addComponent( componentName, {
          switches = {},
          effects = {},
          registerSwitch = function(self, name)
            assert(self.switches[name] == nil, "Switch already exists")
            self.switches[name] = false
          end,
          hasSwitch = function(self, name)
            return self.switches[name] ~= nil
          end,
          addEffect = function(self, switch, name, effect)
            if self.effects[switch] == nil then
              self.effects[switch] = {}
            end
            self.effects[switch][name] = effect
          end,
          removeEffect = function(self, switch, name)
            assert(self.effects[switch][name], "Cannot remove unknown effect " .. switch .. ":" .. name )
            self.effects[switch][name] = nil
          end,
          getEffects = function(self, name)
            if not self.effects[name] then
              return {}
            end
            return self.effects[name]
          end,
          setActive = function(self, name)
            assert( self.hasSwitch(self, name), "Switch " .. name .. " is not registered" )
            if not self.switches[name] == true then
              self.switches[name] = true
              for effectName, effect in pairs(self:getEffects(name)) do
                effect:becomesActive()
              end
            end
          end,        
          setInactive = function(self, name)
            assert( self.hasSwitch(self, name), "Switch is not registered" )
            if not self.switches[name] == false then
              self.switches[name] = false
              for effectName, effect in pairs(self:getEffects(name)) do
                effect:becomesInactive()
              end
            end
          end,
          isActive = function(self, name)
            assert(self.switches[name] ~= nil, name .. " is not a registered Switch")
            return self.switches[name]
          end,
          remove = function(self)
            
          end,
          allowRemoveOtherComponent = function(self, name)
            return true
          end
      })
    end,
    remove = function (entity)
      entity:removeComponent(componentName)
    end,
    get = function (entity)
      return entity:component(componentName)
    end,
    has = function (entity)
      return entity:hasComponent(componentName)
    end,
    isA = function (name, component)
      return name == componentName
    end,
  }
end