local componentName = "inventory"
return function(carryable)  
  return {  
    add = function (entity)
      entity:addComponent(componentName, {
          contents = {},
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return true
          end,
          placeInside = function(self, targetEntity)
            assert(carryable.has(targetEntity) == true, "Only entities that are carryable can be put in an inventory.")
            table.insert(self.contents, targetEntity)
          end,
          countItems = function(self)
            return #self.contents
          end,
          getItems = function(self)
            local tmp = {}
            for k, v in ipairs(self.contents) do
              table.insert(tmp, v)
            end
            return tmp
          end,
          removeFrom = function(self, targetEntity)
            for k, v in ipairs(self.contents) do
              if v == targetEntity then
                table.remove(self.contents, k)
                return
              end
            end
            error("Item was not found in inventory, could not remove")
          end,
      })
    end,

    remove = function (entity)
      entity:removeComponent(componentName)
    end,
    get = function(entity)
      return entity:component(componentName)
    end,
    has = function(entity)
      return entity:hasComponent(componentName)
    end,
  }
end