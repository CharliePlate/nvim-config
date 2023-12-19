local M = {}

M.filter = function(tbl, condition)
  local filtered = {}
  for i, v in ipairs(tbl) do
    if condition(v, i) then
      table.insert(filtered, v)
    end
  end
  return filtered
end

M.isTableOfTables = function(t)
  -- Check if the table is empty
  if next(t) == nil then
    return false
  end

  -- Check if all keys are integers (array-style indexing)
  for key, value in pairs(t) do
    if type(key) ~= "number" then
      return false -- Not an array-style table
    end
    if type(value) ~= "table" then
      return false -- Not containing only tables
    end
  end
  return true
end

return M
