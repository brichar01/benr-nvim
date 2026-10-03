local km = vim.keymap

-- Clip board integration
km.set({ "n" }, "<Leader>sr", '"+dd', { desc = "Cut line to system clipboard", noremap = true })
km.set({ "v" }, "<Leader>sr", '"+d', { desc = "Cut visual selection to system clipboard", noremap = true })

km.set("n", "<Leader>ss", '"+yy', { desc = "Copy line to system clipboard", noremap = true })
km.set("v", "<Leader>ss", '"+y', { desc = "Copy line to system clipboard", noremap = true })

km.set("n", "<Leader>st", '"+p', { desc = "Paste from system cipboard", noremap = true })
km.set("v", "<Leader>st", '"+p', { desc = "Replace selection from system clipboard", noremap = true })

-- Copy filepaths
km.set({ "n" }, "<leader>spr", "<Cmd>HiveContext ref<CR>", { silent = true })
km.set("x", "<leader>spr", ":HiveContext ref<CR>", { silent = true })

km.set({ "n" }, "<leader>spf", "<Cmd>HiveContext rel<CR>", { silent = true })
km.set("x", "<leader>spf", ":HiveContext rel<CR>", { silent = true })

km.set({ "n" }, "<leader>spp", "<Cmd>HiveContext file<CR>", { silent = true })
km.set("x", "<leader>spp", ":HiveContext file<CR>", { silent = true })
