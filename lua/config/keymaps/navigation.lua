-- Extra keymaps that aren't associated with plugins
local km = vim.keymap

km.set("n", ";", ":")
km.set("n", "<Leader>w", "<Cmd>w<CR>", { desc = "Save, duh" })
km.set("n", "<Leader>qq", "<Cmd>confirm q<CR>", { desc = "Quit Window" })
km.set(
  "n",
  "<Leader>qb",
  function() require("mini.bufremove").delete(vim.api.nvim_get_current_buf(), false) end,
  { desc = "Close buffer" }
)
km.set("n", "<Leader>Q", "<Cmd>confirm qall<CR>", { desc = "Quit Nvim" })

km.set("n", "<Esc>", "<Cmd>noh<CR>", { desc = "Clear highlighting" })
km.set("t", "<Esc>", "<C-\\><C-N>", { desc = "", noremap = true })

-- Window navigation and creation
km.set("n", "<C-left>", "<C-W>h", { desc = "Focus left window", noremap = true })
km.set("n", "<C-right>", "<C-W>l", { desc = "Focus right window", noremap = true })
km.set("n", "<C-down>", "<C-W>j", { desc = "Focus above window", noremap = true })
km.set("n", "<C-up>", "<C-W>k", { desc = "Focus below window", noremap = true })

km.set("n", "<C-<>", "<C-W><", { desc = "Decrease window width", noremap = true })
km.set("n", "<C->>", "<C-W>>", { desc = "Increase window width", noremap = true })

km.set("n", "<Leader>nt", "<Cmd>vsplit | terminal<CR>", {})
km.set("n", "<Leader>nd", "<Cmd>vsplit<CR>", {})

km.set("n", "<Leader>tt", "<Cmd>bnext<CR>", { desc = "Next buffer" })
km.set("n", "<Leader>ts", "<Cmd>bprevious<CR>", { desc = "Previous Buffer" })

-- LSP
vim.keymap.set("n", "gri", function()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/implementation" })
  if #clients == 0 then return end
  vim.lsp.buf.implementation()
end, { desc = "Go to implementation" })
