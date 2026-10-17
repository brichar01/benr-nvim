local hive_dir = vim.env.HIVE_DEV and vim.fn.getcwd() .. "/hive.nvim" or "/home/benri/src/hive.nvim"

return {
  "hive.nvim",
  dir = hive_dir,
  main = "hive",
  lazy = false,
  opts = function()
    local function deepseek_key()
      if vim.fn.executable("secret-tool") ~= 1 then return nil end

      local out = vim
        .system({ "secret-tool", "lookup", "service", "deepseek", "key", "api" }, { text = true, timeout = 10000 })
        :wait()
      if out.code ~= 0 then return nil end

      local key = vim.trim(out.stdout or "")
      return key ~= "" and key or nil
    end

    return {
      base_url = "https://api.deepseek.com/chat/completions",
      model = "deepseek-flash",
      api_key_env = "DEEPSEEK_API_KEY",
      api_key = deepseek_key,
      agent = {
        api_key = deepseek_key,
        model = "deepseek-flash",
        effort = "low",
      },
    }
  end,
  keys = {
    {
      "<leader>rb",
      "<cmd>Lazy reload hive.nvim<cr>",
      desc = "Reload hive.nvim",
      mode = { "n", "v" },
    },
  },
}
