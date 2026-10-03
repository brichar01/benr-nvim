-- Scratch and workspace windows
local km = vim.keymap

km.set("n", "<leader>ns", ":vsplit | Scratch<CR>", { silent = true })
km.set("n", "<leader>nw", ":vsplit | HiveContext workbench open<CR>", { silent = true })
km.set("n", "<Leader>ne", "<Cmd>HiveContext workbench next<CR>")
km.set("n", "<Leader>nb", "<Cmd>HiveContext workbench previous<CR>")
