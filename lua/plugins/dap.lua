local Util = require("util")

local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

return {
	{
		"mfussenegger/nvim-dap",

		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
      -- stylua: ignore
      keys = {
        { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
        { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
      },
				opts = {},
				config = function(_, opts)
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup(opts)
					dap.listeners.after.event_initialized["dapui_config"] = function()
						dapui.open({})
					end
					dap.listeners.before.event_terminated["dapui_config"] = function()
						dapui.close({})
					end
					dap.listeners.before.event_exited["dapui_config"] = function()
						dapui.close({})
					end
				end,
			},

			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},

			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = "mason.nvim",
				cmd = { "DapInstall", "DapUninstall" },
				opts = {
					automatic_installation = true,
					handlers = {},
					ensure_installed = {},
				},
			},
		},

  -- stylua: ignore
  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },
		config = function(_, opts)
			local ports = {
				["Answers"] = 9230,
				["Public API"] = 9201,
				["Web API"] = 9229,
				["Worker"] = 9231,
			}

			local dap = require("dap")

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						require("mason-registry").get_package("js-debug-adapter"):get_install_path()
							.. "/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			local typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
					outFiles = { "${workspaceFolder}/dist/**/*.js" },
					runtimeExecutable = "/Users/charlieplate/.yarn/bin/ts-node",
				},
			}

			local GRAPHITE_DIR = "/Users/charlieplate/Documents/work/graphite" .. ".*"

			if string.match(vim.fn.getcwd(), GRAPHITE_DIR) then
				local sorted_ports = {}
				for k, v in pairs(ports) do
					table.insert(sorted_ports, { k, v })
				end
				table.sort(sorted_ports, function(a, b)
					return a[1] < b[1]
				end)

				for _, port in ipairs(sorted_ports) do
					table.insert(typescript, {
						type = "pwa-node",
						request = "attach",
						port = port[2],
						name = "Attach to " .. port[1],
						sourceMaps = true,
						protocol = "inspector",
						console = "integratedTerminal",
						outFiles = { "${workspaceFolder}/dist/**/*.js" },
						webRoot = "${workspaceFolder}/src",
						remoteRoot = "${workspaceFolder}/src",
					})
				end
			end

			dap.configurations.typescript = typescript

			dap.defaults.typescript.exception_breakpoints = { "raised", "exception" }

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(Util.icons.dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end
		end,
	},
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
}
