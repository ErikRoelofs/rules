return {
  add = function (entity, line, output)
    if not entity:hasEntity("ruleState") then
      error("Only entities with RuleState can have PrintEffect")
    end
    local lineToPrint = line
    local outputHandler = output
    entity:addEntity("printEffect", {
      becomesActive = function()
        outputHandler:printOut(lineToPrint)
      end,
      becomesInactive = function()
      end,
      allowRemoveOtherEntity = function(self, name)
        return name ~= "ruleState"
      end,
      remove = function(self)
        
      end
    })
    entity:entity("ruleState"):addEffect("print", entity:entity("printEffect"))
  end,
  remove = function (entity)
    entity:removeEntity("printEffect")
  end
}