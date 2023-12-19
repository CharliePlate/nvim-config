local Dap = require("util.dap")
local Lang = require("util.lang")

return Lang.makeSpec({
  Lang.addLspServer("tsserver"),
  Lang.addFormatter({
    typescript = { { "prettierd" } },
    javascript = { { "prettierd" } },
    typescriptreact = { { "prettierd" } },
    javascriptreact = { { "prettierd" } },
  }),
  Lang.addDap("js-debug-adapter"),
  Lang.addTreesitterFiletypes({ "typescript", "javascript" }),
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end
      for _, language in ipairs({ "typescript", "typescriptreact", "javascriptreact" }) do
        if not dap.configurations[language] and not Dap.root_is_configured() then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = vim.fn.getcwd(),
              sourceMaps = true,
              protocol = "inspector",
              console = "integratedTerminal",
              outFiles = { "${workspaceFolder}/dist/**/*.js" },
              runtimeExecutable = "/Users/charlieplate/.yarn/bin/ts-node",
            },
          }
        end
      end
    end,
  },
  {
    "David-Kunz/jester",
    opts = {
      cmd = "jest -t '$result' -- $file", -- run command
      identifiers = { "test", "it" }, -- used to identify tests
      prepend = { "describe" }, -- prepend describe blocks
      expressions = { "call_expression" }, -- tree-sitter object used to scan for tests/describe blocks
      path_to_jest_run = "jest", -- used to run tests
      path_to_jest_debug = "/Users/charlieplate/.yarn/bin/jest", -- used for debugging
      terminal_cmd = ":vsplit | terminal", -- used to spawn a terminal for running tests, for debugging refer to nvim-dap's config
      dap = { -- debug adapter configuration
        type = "pwa-node",
        request = "launch",
        port = 9229,
        name = "Jest",
        sourceMaps = true,
        protocol = "inspector",
        runtimeArgs = { "--inspect-brk", "$path_to_jest", "--no-coverage", "-t", "$result", "--", "$file" },
        console = "integratedTerminal",
        outFiles = { "${workspaceFolder}/dist/**/*.js" },
        webRoot = "${workspaceFolder}/src",
        remoteRoot = "${workspaceFolder}/src",
      },
    },
    config = function(_, opts)
      require("jester").setup(opts)
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dtd",
        "<cmd>lua require'jester'.run_file()<cr>",
        { noremap = true, desc = "Debug test" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dtr",
        "<cmd>lua require'jester'.run()<cr>",
        { noremap = true, desc = "Run test" }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<leader>dtf",
        "<cmd>lua require'jester'.run_file()<cr>",
        { noremap = true, desc = "Run file" }
      )
    end,
    ft = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
    },
    opts = function(_, opts)
      return {
        adapters = vim.list_extend(opts.adapters, {
          require("neotest-jest")({}),
        }),
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
  },
  {
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      print(vim.inspect(vim.fn.stdpath("config") .. "/lua/dev/ts-pretty-errors"))
    end,
    dir = vim.fn.stdpath("config") .. "/lua/dev/ts-pretty-errors",
  },
})
