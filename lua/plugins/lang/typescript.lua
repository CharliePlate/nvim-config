local Lang = require("util.lang")

return Lang.makeSpec({
	Lang.addLspServer("tsserver"),
	Lang.addFormatter({
		typescript = { { "prettierd" } },
		javascript = { { "prettierd" } },
		typescriptreact = { { "prettierd" } },
		javascriptreact = { { "prettierd" } },
	}),
	{
		"David-Kunz/jester",
		opts = {
			cmd = "jest -t '$result' -- $file", -- run command
			identifiers = { "test", "it" }, -- used to identify tests
			prepend = { "describe" }, -- prepend describe blocks
			expressions = { "call_expression" }, -- tree-sitter object used to scan for tests/describe blocks
			path_to_jest_run = "jest", -- used to run tests
			path_to_jest_debug = "/Users/charlieplate/.yarn/bin/jest", -- used for debugging
			terminal_cmd = ":vsplit | terminal", -- used to spawn a terminal for running tests, for debugging refer to nvim-dap's config
			dap = { -- debug adapter configuration
				type = "pwa-node",
				request = "launch",
				port = 9229,
				name = "Jest",
				sourceMaps = true,
				protocol = "inspector",
				runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
				console = "integratedTerminal",
				outFiles = { "${workspaceFolder}/dist/**/*.js" },
				webRoot = "${workspaceFolder}/src",
				remoteRoot = "${workspaceFolder}/src",
			},
		},
		filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
		keys = {
			{ "<leader>t", desc = "Test" },
			{ "<leader>dtd", "<cmd>lua require'jester'.debug()<cr>", desc = "Debug test" },
			{ "<leader>dtr", "<cmd>lua require'jester'.run()<cr>", desc = "Run test" },
			{ "<leader>dtf", "<cmd>lua require'jester'.run_file()<cr>", desc = "Run file" },
			{ "<leader>dtD", "<cmd>lua require'jester'.debug_last()<cr>", desc = "Debug last" },
			{ "<leader>dtR", "<cmd>lua require'jester'.run_last()<cr>", desc = "Run last" },
		},
	},
})
