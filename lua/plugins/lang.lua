local Lang = require("util.lang")

return {
	-- Go
	{
		"leoluz/nvim-dap-go",
		config = true,
	},
	Lang.addFormatter({ go = { { "goimports", "gofumpt" } } }),
}
