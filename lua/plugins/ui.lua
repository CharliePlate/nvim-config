return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		opts = {},
		init = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = {
				enabled = true,
				view = "cmdline",
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = false,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "LazyFile",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
		main = "ibl",
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = "LazyFile",
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			sections = require("util.lualine"),
		},
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			local icon = {
				[[]],
				[[]],
				[[]],
				[[]],
				[[]],
				[[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
				[[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
				[[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
				[[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
				[[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
				[[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
				[[]],
				[[]],
			}

			require("dashboard").setup({
				theme = "doom",
				hide = {
					statusline = false,
				},
				config = {
					header = icon,
          -- stylua: ignore
          center = {
            { action = "Telescope find_files",                                                    desc = " Find file",       icon = " ", key = "f" },
            { action = "ene | startinsert",                                                       desc = " New file",        icon = " ", key = "n" },
            { action = "Telescope oldfiles",                                                      desc = " Recent files",    icon = " ", key = "r" },
            { action = "Telescope live_grep",                                                     desc = " Find text",       icon = " ", key = "g" },
            { action = "require('telescope.builtin').find_files({cwd=vim.fn.stdpath('config')})", desc = " Config",          icon = " ", key = "c" },
            { action = 'lua require("persistence").load()',                                       desc = " Restore Session", icon = " ", key = "s" },
            { action = "Lazy",                                                                    desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = "qa",                                                                      desc = " Quit",            icon = " ", key = "q" },
          },
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			})
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}
