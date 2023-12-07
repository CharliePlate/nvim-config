local Util = require("util")

return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		opts = {
			win_options = {
				signcolumn = "no",
				statuscolumn = "",
				foldcolumn = "0",
				spell = false,
				list = false,
				conceallevel = 3,
				relativenumber = false,
			},
			default_file_explorer = true,
		},
		keys = {
			{ "-", "<cmd>Oil<cr>" },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					require("telescope").load_extension("fzf")
					require("telescope").load_extension("lazygit")
				end,
			},
		},
    -- stylua: ignore
		keys = {
			{ "<leader>ff", function() require('telescope.builtin').find_files() end, desc = "Find Files (Root)" },
      { "<leader>fF", function() require('telescope.builtin').find_files({cwd=Util.root()}) end, desc = "Find Files (LSP)"},
      { "<leader>fg", function() require('telescope.builtin').live_grep() end, desc = "Grep (Root)" },
      { "<leader>fG", function() require('telescope.builtin').live_grep({cwd=Util.root()}) end, desc = "Grep (LSP)"}
		},
	},
	{
		"folke/which-key.nvim",
		lazy = false,
		opts = {
			["<leader>g"] = { name = "+git" },
			["<leader>f"] = { name = "+find" },
			["<leader>q"] = { name = "+session" },
		},

		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts)
		end,
	},
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup({})
		end,
    -- stylua: ignore
		keys = {
			{ "<leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon File" },
			{ "<c-e>", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Quick Menu" },
			{ "<c-h>", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1" },
			{ "<c-j>", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2" },
			{ "<c-k>", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3" },
			{ "<c-l>", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4" },
		},
	},
}
