return {
  add = function (entity, line, output)
    if not entity:hasComponent("ruleState") then
      error("Only entities with RuleState can have PrintEffect")
    end
    local lineToPrint = line
    local outputHandler = output
    entity:addComponent("printEffect", {
      becomesActive = function()
        outputHandler:printOut(lineToPrint)
      end,
      becomesInactive = function()
      end,
      allowRemoveOtherComponent = function(self, name)
        return name ~= "ruleState"
      end,
      remove = function(self)
        
      end
    })
    entity:component("ruleState"):addEffect("print", entity:component("printEffect"))
  end,
  remove = function (entity)
    entity:removeComponent("printEffect")
  end
}