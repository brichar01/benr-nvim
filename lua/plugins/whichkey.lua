---@type LazySpec
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>a", group = "Surround" },
      { "<leader>c", group = "Code" },
      { "<leader>f", group = "Find" },
      { "<leader>h", group = "Git hunk" },
      { "<leader>n", group = "Open" },
      { "<leader>q", group = "Quit" },
      { "<leader>r", group = "Refactor" },
      { "<leader>s", group = "Clipboard" },
      { "<leader>sp", group = "Copy path" },
      { "<leader>t", group = "Buffers and toggles" },
      { "<leader>x", group = "Diagnostics" },
    },
  },
  keys = {
    {
      "<leader>K",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
