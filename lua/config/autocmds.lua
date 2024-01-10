local Util = require("util.root")

local root_names = { ".git", "Makefile", "Cargo.toml", "go.mod" }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}
local set_root = function()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = vim.fn.getcwd()
  end
  -- path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then
      return
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  -- Set current directory
  if vim.g.starting_root == nil then
    vim.g.starting_root = root
  end

  vim.fn.chdir(root)
end

local group = vim.api.nvim_create_augroup("GlobalConfig", { clear = true })

-- Setup basic util stuff
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    Util.setup()
  end,
})

-- On buffer enter, set the pwd
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function()
    set_root()
    vim.api.nvim_exec_autocmds("User", { pattern = "RootLoaded" })
  end,
})

-- When reading or creating a new file, set that buffer eol to true
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = group,
  callback = function()
    vim.o.eol = true
  end,
})

-- return last position when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  group = group,
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})
