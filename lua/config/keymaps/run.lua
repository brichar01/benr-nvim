local km = vim.keymap
-- Running in
km.set("x", "<leader>nr", ":Run<CR>", { silent = true })
km.set("n", "<leader>nr", "<Cmd>Run<CR>", { silent = true })
