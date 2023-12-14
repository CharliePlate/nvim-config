local M = {}

---@param formatter table<string, table<table<string>>> | table<string>
M.addFormatter = function(formatter)
	return {
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = formatter,
			},
			{
				"williamboman/mason.nvim",
				opts = function(_, masonOpts)
					masonOpts.ensure_installed = masonOpts.ensure_installed or {}
					for _, value in pairs(formatter) do
						vim.list_extend(masonOpts.ensure_installed, value)
					end
				end,
			},
		},
	}
end

return M
