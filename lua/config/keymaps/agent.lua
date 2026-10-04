-- Hive agent prompts
local km = vim.keymap

km.set("n", "<Leader>p", function()
  local line = vim.trim(vim.api.nvim_get_current_line())
  if line == "" then return vim.notify("Hive: empty line", vim.log.levels.ERROR) end
  local row = vim.fn.line(".")
  line = require("hive.context.path").snippet(row, row, line)

  vim.ui.input({ prompt = "Hive: " }, function(input)
    if input == nil then return end
    input = vim.trim(input)

    local err = require("hive.agent").prompt(input == "" and line or line .. "\n" .. input)
    if err then vim.notify("Hive: " .. err, vim.log.levels.ERROR) end
  end)
end, { desc = "Prompt the agent with the cursor line and an instruction" })
km.set("x", "<Leader>p", ":Hive selection<CR>", { desc = "Prompt the agent with the selection", silent = true })
