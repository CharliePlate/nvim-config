return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { { "stylua" } },
        typescript = { { "prettierd" } },
        javascript = { { "prettierd" } },
        typescriptreact = { { "prettierd" } },
        javascriptreact = { { "prettierd" } },
        json = { { "prettierd" } },
        go = { "goimports", "gofumpt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
