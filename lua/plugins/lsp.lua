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
    },
    event = "LazyFile",
    opts = {
      servers = {},
      inlayHints = {},
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
        if opts.inlayHints[client.name] then
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(buffer, true)
          end
        end
      end)

      local mason = require("mason-lspconfig")

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

    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
}
