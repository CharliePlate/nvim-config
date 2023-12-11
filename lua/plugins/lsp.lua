-- Utility Function to handle
function On_Attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "folke/neodev.nvim", opts = {} },
		},
		event = "LazyFile",
		config = function()
			On_Attach(function(client, buffer)
				require("config.keymaps.lsp").set_binds(client, buffer)
			end)

			local register_capability = vim.lsp.handlers["client/registerCapability"]

			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				local ret = register_capability(err, res, ctx)
				local client_id = ctx.client_id
				local client = vim.lsp.get_client_by_id(client_id)
				local buffer = vim.api.nvim_get_current_buf()
				require("config.keymaps.lsp").set_binds(client, buffer)
				return ret
			end

			local mason = require("mason-lspconfig")
			mason.setup()
			mason.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})
		end,
		keys = {
			{ "<leader>li", "<cmd>Mason<cr>", "Mason" },
			{ "<leader>lI", "<cmd>LspInfo<cr>", "Lsp Info" },
			{ "<leader>lR", "<cmd>LspRoot<cr>", "Lsp Root" },
		},
	},
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
	},
}
