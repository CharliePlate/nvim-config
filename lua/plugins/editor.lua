local Util = require("util")

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.files",
    version = "*",
    opts = {
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "<cr>",
        go_out = "-",
        go_out_plus = "H",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
    },
    keys = {
      { "-", "<cmd>lua MiniFiles.open()<cr>" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("telescope").load_extension("fzf")
          require("telescope").load_extension("lazygit")
        end,
      },
    },
    opts = function()
      return {
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            previewer = false,
            mappings = {
              i = {
                ["<c-d>"] = "delete_buffer",
              },
              n = {
                ["d"] = "delete_buffer",
              },
            },
          },
        },
      }
    end,
    -- stylua: ignore
		keys = {
      { "<leader>ff", function() require('telescope.builtin').find_files({cwd=Util.root()}) end, desc = "Find Files (LSP)"},
			{ "<leader>fF", function() require('telescope.builtin').find_files() end, desc = "Find Files (Root)" },
      { "<leader>fg", function() require('telescope.builtin').live_grep({cwd=Util.root()}) end, desc = "Grep (LSP)"},
      { "<leader>fG", function() require('telescope.builtin').live_grep() end, desc = "Grep (Root)" },
      { "<leader>fb", function() require('telescope.builtin').buffers() end, desc = "Buffers"}
		},
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
      keys = {
        ["<leader>g"] = { name = "+git" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>q"] = { name = "+session" },
        ["<leader>d"] = { name = "debug", ["t"] = { name = "test" } },
        ["<leader>l"] = { name = "lsp" },
      },

      config = {
        triggers_nowait = {
          -- marks
          "`",
          "'",
          "g`",
          "g'",
          -- registers
          '"',
          "<c-r>",
          -- spelling
          "z=",
          "<c-k>",
        },
      },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts.config)
      wk.register(opts.keys)

      vim.api.nvim_del_keymap("n", "<C-k>")
    end,
  },
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup({})
    end,
    -- stylua: ignore
		keys = {
			{ "<leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon File" },
			{ "<c-e>", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Quick Menu" },
			{ "<c-h>", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1" },
			{ "<c-j>", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2" },
			{ "<c-k>", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3" },
			{ "<c-l>", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4" },
		},
  },
  {
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      keys = {
        { [[<c-\>]], "<cmd>ToggleTerm<cr>", desc = "ToggleTerm" },
      },
      opts = {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      },
    },
  },
  {
    {
      "chrisgrieser/nvim-origami",
      event = "BufReadPost", -- later will not save folds
      opts = true, -- needed
    },
    {
      "kevinhwang91/nvim-ufo",
      dependencies = "kevinhwang91/promise-async",
      event = "BufReadPost",
      init = function()
        vim.opt.foldlevel = 99
        vim.opt.foldlevelstart = 99
      end,
      opts = {
        provider_selector = function(_, ft, _)
          local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css" }
          if vim.tbl_contains(lspWithOutFolding, ft) then
            return { "treesitter", "indent" }
          elseif ft == "html" then
            return { "indent" } -- lsp & treesitter do not provide folds
          else
            return { "lsp", "indent" }
          end
        end,
        -- open opening the buffer, close these fold kinds
        -- use `:UfoInspect` to get available fold kinds from the LSP
        close_fold_kinds = { "imports" },
        open_fold_hl_timeout = 500,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local foldIcon = ""
          local hlgroup = "NonText"
          local newVirtText = {}
          local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, hlgroup })
          return newVirtText
        end,
      },
    },
  },
}
