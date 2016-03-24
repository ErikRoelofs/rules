return function() 
  return {
    printOut = function(self, text)
      table.insert(self.lines, text)
    end,
    lines = {}
  }
end