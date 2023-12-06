vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt
opt.clipboard = "unnamedplus" -- System Clipboard
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.wrap = false -- Disable line wrap
opt.undodir = vim.fn.expand("~/.cache/vim/undodir")
opt.pumblend = 0
opt.eol = true
vim.o.listchars = "tab:│ ,trail:·,extends:»,precedes:«,nbsp:␣"

vim.diagnostic.config({
	float = { border = "rounded" },
})
