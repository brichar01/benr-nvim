local km = vim.keymap
-- Running in
km.set("x", "<leader>nr", ":Run<CR>", { silent = true })
km.set("n", "<leader>nr", "<Cmd>Run<CR>", { silent = true })
km.set("x", "<leader>nm", ":Mermaid<CR>", { silent = true, desc = "Mermaid diagram to SVG" })
km.set("n", "<leader>nm", "<Cmd>Mermaid<CR>", { silent = true, desc = "Mermaid diagram to SVG" })
