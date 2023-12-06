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
				end,
			},
		},
		keys = {
			{ "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find Files" },
		},
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
	},
	{
		"theprimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup()
		end,
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon"):list():append()
				end,
				desc = "harpoon file",
			},
			{
				"<c-e>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "harpoon quick menu",
			},
			{
				"<c-h>",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "harpoon to file 1",
			},
			{
				"<c-j>",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "harpoon to file 2",
			},
			{
				"<c-k>",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "harpoon to file 3",
			},
			{
				"<c-k>",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "harpoon to file 4",
			},
		},
	},
}
