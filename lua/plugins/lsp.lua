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
		opts = {
			servers = {
				jsonls = require("config.lsp.jsonls"),
				gopls = require("config.lsp.gopls"),
			},
			inlayHints = false,
		},
		config = function(_, opts)
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

			for name, icon in pairs(require("util.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			On_Attach(function(client, buffer)
				if client.supports_method("textDocument/inlayHint") and opts.inlayHints then
					vim.lsp.inlay_hint.enable(buffer, true)
				end
			end)

			local mason = require("mason-lspconfig")
			mason.setup({
				ensure_installed = { "lua_ls", "tsserver", "jsonls", "gopls" },
			})
			mason.setup_handlers({

				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			})

			for server, server_opts in pairs(opts.servers) do
				require("lspconfig")[server].setup(server_opts)
			end
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
