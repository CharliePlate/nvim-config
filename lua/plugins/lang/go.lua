local Lang = require("util.lang")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.templ",
  command = 'silent! !PATH="$PATH:$(go env GOPATH)/bin" templ fmt <afile> >/dev/null 2>&1',
  group = vim.api.nvim_create_augroup("TemplFmt", { clear = true }),
})

return Lang.makeSpec({
  Lang.addFormatter({ go = { "goimports", "gofumpt" } }),
  Lang.addTreesitterFiletypes({
    "go",
    "gomod",
    "gowork",
    "gosum",
  }),
  Lang.addLspServer("gopls", true),
  Lang.addLspServer("templ"),
  Lang.addDap("delve"),
  {
    "leoluz/nvim-dap-go",
    config = true,
  },
})
