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
	print(value)
	if value ~= nil then
		M.setGlobal(string.lower(var), value)
	end
end

return M
