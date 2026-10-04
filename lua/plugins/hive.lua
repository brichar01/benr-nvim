return {
  "hive.nvim",
  dir = "/home/benri/src/hive.nvim",
  main = "hive",
  lazy = false,
  opts = function()
    local function mistral_key()
      if vim.fn.executable("secret-tool") ~= 1 then return nil end

      local out = vim
        .system({ "secret-tool", "lookup", "service", "mistral", "key", "api" }, { text = true, timeout = 10000 })
        :wait()
      if out.code ~= 0 then return nil end

      local key = vim.trim(out.stdout or "")
      return key ~= "" and key or nil
    end

    return {
      base_url = "https://api.mistral.ai",
      model = "codestral-latest",
      api_key_env = "MISTRAL_API_KEY",
      api_key = mistral_key,
      agent = {
        api_key = mistral_key,
        model = "codestral-latest",
        effort = "high",
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
