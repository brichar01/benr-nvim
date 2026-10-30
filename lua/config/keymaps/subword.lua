local km = vim.keymap
local subword = require("utils.subword")

-- WezTerm sends Alt+Backspace for Ctrl+Backspace
km.set(
  "i",
  "<M-BS>",
  function() return ("<BS>"):rep(subword.length_before_cursor()) end,
  { expr = true, desc = "Backspace subword" }
)

km.set("n", "ds", subword.normal_keys, { expr = true, desc = "Backspace subword" })
