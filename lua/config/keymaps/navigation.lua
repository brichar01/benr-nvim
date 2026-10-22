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
local function has_lsp_locations(results)
  for _, res in pairs(results) do
    if res.result and not vim.tbl_isempty(res.result) then return true end
  end
  return false
end

km.set("n", "grd", vim.lsp.buf.definition, { desc = "Go to definition" })

km.set("n", "gri", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/implementation" })
  if #clients == 0 then return end

  vim.lsp.buf_request_all(
    bufnr,
    "textDocument/implementation",
    function(client) return vim.lsp.util.make_position_params(0, client.offset_encoding) end,
    function(results)
      if has_lsp_locations(results) then
        vim.lsp.buf.implementation()
      elseif vim.bo[bufnr].filetype == "c" then
        -- clangd returns no implementations for plain C functions.
        -- Fall back to clangd's source/header switch instead.
        vim.api.nvim_buf_call(bufnr, function() vim.cmd("LspClangdSwitchSourceHeader") end)
      else
        vim.notify("No locations found", vim.log.levels.INFO)
      end
    end
  )
end, { desc = "Go to implementation (C: fallback to source/header)" })
