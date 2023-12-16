local Util = require("util")

return {
	{ "nvim-lua/plenary.nvim" },
	{
		"folke/persistence.nvim",
		lazy = true,
		opts = {},
		config = function(_, opts)
			local persistance = require("persistence")
			persistance.setup(opts)
			if vim.fn.getcwd() ~= vim.g.starting_root then
				persistance.stop()
			end
		end,
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Load Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Load Last Session",
			},
		},
	},
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
