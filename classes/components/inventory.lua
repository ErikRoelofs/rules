local componentName = "inventory"
return function(carryable)  
  return {  
    add = function (entity)
      local contents = {}
      entity:addComponent(componentName, {          
          remove = function()
            
          end,
          allowRemoveOtherComponent = function(self, name, component)
            return true
          end,
          placeInside = function(self, targetEntity)
            assert(carryable.has(targetEntity) == true, "Only entities that are carryable can be put in an inventory.")
            table.insert(contents, targetEntity)
          end,
          countItems = function(self)
            return #contents
          end,
          getItems = function(self)
            local tmp = {}
            for k, v in ipairs(contents) do
              table.insert(tmp, v)
            end
            return tmp
          end,
          removeFrom = function(self, targetEntity)
            for k, v in ipairs(contents) do
              if v == targetEntity then
                table.remove(contents, k)
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