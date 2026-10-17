---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  keys = {
    {
      "<Leader>o",
      "<CMD>Neotree toggle<CR>",
    },
  },
  opts = {
    filesystem = {
      check_gitignore_in_search = false,

      filtered_items = {
        visible = false,
        hide_gitignored = false,
        hide_ignored = false,
        ignore_files = {
          ".neotreeignore",
          ".ignore",
        },
        -- remains visible even if other settings would normally hide it
        always_show = {
          ".gitignore",
          ".clangd",
        },
      },
    },
  },
}
