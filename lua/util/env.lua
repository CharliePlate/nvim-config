---@class vim.var_accessor
---@field nvim_work_dir string
---@field dap_config_loaded boolean
vim.g = vim.g

local M = {}

---@param var string
M.getEnvVar = function(var)
  local value = vim.fn.getenv(var)
  if value == "" then
    return nil
  end
  return value
end

---@param name string
---@param value string
M.setGlobal = function(name, value)
  vim.g[name] = value
end

---@param var string
M.setGlobalFromEnv = function(var)
  local value = M.getEnvVar(var)
  if value ~= nil then
    M.setGlobal(string.lower(var), value)
  else
    M.setGlobal(string.lower(var), "xxxxxxxx")
  end
end

return M
