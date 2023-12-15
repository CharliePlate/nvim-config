---@class Lang
local M = {}

---@private
---@param t table
---@return boolean
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

M.makeSpec = function(t)
	local spec = {}
	for _, value in ipairs(t) do
		if M.isTableOfTables(value) then
			for _, v in ipairs(value) do
				table.insert(spec, v)
			end
		else
			table.insert(spec, value)
		end
	end
	return spec
end

---@param formatter table<string, table<table<string>>> | table<string>
---@return table
M.addFormatter = function(formatter)
	return {
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = formatter,
			},
		},
		{
			"williamboman/mason.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				for _, value in pairs(formatter) do
					if M.isTableOfTables(value) then
						for _, v in ipairs(value) do
							vim.list_extend(opts.ensure_installed, v)
						end
					else
						vim.list_extend(opts.ensure_installed, value)
					end
				end
			end,
		},
	}
end

---@param filetypes string[]
M.addTreesitterFiletypes = function(filetypes)
	return {
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, filetypes)
		end,
	}
end

---@param lsp string
---@param hints? boolean
M.addLspServer = function(lsp, hints)
	return {
		{
			"neovim/nvim-lspconfig",
			opts = function(_, opts)
				local ok, config = pcall(require, "config.lsp." .. lsp)
				if ok then
					opts.servers = vim.tbl_deep_extend("force", opts.servers or {}, { [lsp] = config })
				end
				if hints then
					opts.inlayHints = opts.inlayHints or {}
					opts.inlayHints[lsp] = true
				end
			end,
		},
		{
			"williamboman/mason-lspconfig",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, lsp)
			end,
		},
	}
end

M.addDap = function(s)
	return {
		{
			"jay-babu/mason-nvim-dap.nvim",
			opts = function(_, opts)
				opts.ensure_installed = opts.ensure_installed or {}
				table.insert(opts.ensure_installed, s)
			end,
		},
	}
end

return M
