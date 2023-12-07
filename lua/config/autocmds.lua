local Util = require("util.root")

local group = vim.api.nvim_create_augroup("GlobalConfig", { clear = true })

vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "VeryLazy",
	callback = function()
		Util.setup()
	end,
})
