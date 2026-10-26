return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    sections = {
      lualine_x = {
        {
          function()
            return vim.b.md_block_lang or ""
          end,
          cond = function()
            return vim.b.md_block_lang ~= nil
          end,
        },
        "encoding",
        "fileformat",
        {
          function()
            local ok, scope = pcall(require, "hive.context.scope")
            if not ok then return "" end
            return table.concat(vim.tbl_map(function(link) return link.name end, scope.chain()), ".")
          end,
        },
        "filetype",
      },
    },
  },
}
