local M = {}
---@class ReminderConfig
---@field include_deleted? boolean
---@field while_away_notifications? boolean
---@field persist_file? string
---@field reminders? ReminderTimerSpec[]

---@type ReminderConfig
local default_config = {
  include_deleted = false,
  while_away_notifications = true,
  persist_file = vim.fn.stdpath("cache") .. "/reminder.json",
  reminders = {},
}

---@param config? ReminderConfig
M.setup = function(config)
  M.config = vim.tbl_deep_extend("force", default_config, config or {})

  vim.g.active_reminders = {}

  for _, timerSpec in pairs(M.config.reminders) do
    print("adding " .. timerSpec.name .. " to active_reminders")
    table.insert(vim.g.active_reminders, timerSpec)
  end

  -- M.persist = require("reminder.persist"):new(M.config)

  -- a.run(function()
  --   M.persist:get_file(M.config.persist_file)
  --   local specs = M.persist:make_active_timer_specs()
  --   for _, spec in ipairs(specs) do
  --     vim.g.active_reminders[spec.name] = spec
  --   end
  -- end, function()
  --   print("success!")
  -- end)
end

return M
