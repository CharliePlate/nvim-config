local Lang = require("util.lang")

return Lang.makeSpec({
	Lang.addFormatter({ go = { "goimports", "gofumpt" } }),
	Lang.addTreesitterFiletypes({
		"go",
		"gomod",
		"gowork",
		"gosum",
	}),
	Lang.addLspServer("gopls", true),
	Lang.addDap("delve"),
	{
		"leoluz/nvim-dap-go",
		config = true,
	},
})
