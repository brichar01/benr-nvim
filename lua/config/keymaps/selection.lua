local km = vim.keymap
-- Search for a selection
km.set("x", "<leader>fw", ":TelescopeVisualGrep<CR>", { desc = "Find selection" })

-- Selection by treesitter node
km.set(
  { "n", "x" },
  "vs<Left>",
  "<Cmd>HiveContext select parent<CR>",
  { desc = "Select current method, class, etc.", noremap = true }
)

km.set(
  "x",
  "<C-Left>",
  ":HiveContext select parent<CR>",
  { desc = "Expand to next method, class, etc.", noremap = true }
)

km.set("n", "vsi", "<Cmd>HiveContext select call<CR>", { desc = "Select the enclosing call", silent = true })
km.set("x", "vsi", ":HiveContext select call<CR>", { desc = "Expand to the enclosing call", silent = true })

km.set("n", "vsm", "<Cmd>HiveContext select method<CR>", { desc = "Select the enclosing method", silent = true })
km.set("x", "vsm", ":HiveContext select method<CR>", { desc = "Expand to the enclosing method", silent = true })

km.set("n", "vsc", "<Cmd>HiveContext select class<CR>", { desc = "Select the enclosing class", silent = true })
km.set("x", "vsc", ":HiveContext select class<CR>", { desc = "Expand to the enclosing class", silent = true })
