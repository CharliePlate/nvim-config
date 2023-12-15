local Lang = require("util.lang")

return Lang.makeSpec({
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
		},
	},
	Lang.addLspServer("lua_ls"),
	Lang.addFormatter({ lua = { { "stylua" } } }),
	Lang.addTreesitterFiletypes({ "lua" }),
})
