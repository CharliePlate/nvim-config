---@class Env
---@field nvim_work_dir string
vim.g = vim.g

local Env = require("util.env")

Env.setGlobalFromEnv("NVIM_WORK_DIR")
