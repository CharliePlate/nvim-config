local Util = require("util")

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      local Cond = require("nvim-autopairs.conds")
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup(opts)

      npairs.add_rule(Rule(">[%w%s]*$", "^%s*</", {
        "templ",
      }):only_cr():use_regex(true))

      npairs.add_rule(Rule("<!--", "-->", "templ"):with_cr(Cond.none()))
    end,
  },
  {
    "echasnovski/mini.files",
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
    config = function(_, opts)
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowUpdate",
        callback = function(args)
          vim.wo[args.data.win_id].relativenumber = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client.supports_method("workspace/willRenameFiles") then
              ---@diagnostic disable-next-line: invisible
              local resp = client.request_sync("workspace/willRenameFiles", {
                files = {
                  {
                    oldUri = vim.uri_from_fname(event.data.from),
                    newUri = vim.uri_from_fname(event.data.to),
                  },
                },
              }, 1000, 0)
              if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
              end
            end
          end
        end,
      })
    end,
    keys = {
      {
        "-",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
          require("mini.files").reveal_cwd()
        end,
        desc = "File Explorer",
      },
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
        ["<leader>d"] = { name = "+debug", ["t"] = { name = "test" } },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>x"] = { name = "+diagnostic" },
        ["<leader>c"] = { name = "+coding" },
        ["<leader>t"] = { name = "+test" },
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
    end,
  },
  {
    "otavioschwanck/arrow.nvim",
    event = "RootLoaded",
    opts = {
      show_icons = true,
      leader_key = "<c-_>",
    },
    config = function(_, opts)
      require("arrow").setup(opts)

      local Keys = require("util.keys")
      -- stylua: ignore
      ---@type LazyKeysSpec[]
      local maps = {
        { "<leader>a", function() require("arrow.persist").save(require("arrow.utils").get_path_for("%")) end, desc = "Arrow Action" },
        { "<c-n>", function() require("arrow.persist").next() end, desc = "Next Arrow" },
        { "<c-p>", function() require("arrow.persist").previous() end, desc = "Previous Arrow"},
      }

      Keys.addAndSet(maps)
    end,
  },
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
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
