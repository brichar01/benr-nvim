local group = vim.api.nvim_create_augroup("MarkdownBlockLang", { clear = true })

-- Language of the fenced code block under the cursor, or "markdown" when the
-- cursor is outside a block or no parser is installed for the block's language.
local function block_lang(buf)
  local parser = vim.treesitter.get_parser(buf)
  if not parser then return "markdown" end
  parser:parse(true) -- `true` resolves injections; a plain parse() will not

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row - 1, col }, lang = "markdown" })
  while node and node:type() ~= "fenced_code_block" do
    node = node:parent()
  end
  if not node then return "markdown" end

  local lang = parser:language_for_range({ row - 1, col, row - 1, col }):lang()
  -- No parser installed for the fence's language => no injection => markdown.
  if lang == "markdown" or lang == "markdown_inline" then return "markdown" end
  return lang
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "markdown",
  callback = function(ev)
    vim.b[ev.buf].md_block_lang = "markdown"
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = ev.buf,
      callback = function() vim.b[ev.buf].md_block_lang = block_lang(ev.buf) end,
    })
  end,
})

-- In a workbench belonging to the current workspace, <leader>p sends the
-- unanswered text to the agent. Entering any other buffer restores the map.
local workbench_group = vim.api.nvim_create_augroup("HiveWorkbenchKeymap", { clear = true })
local original_map
local overridden = false

local function is_current_workbench(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" or name:sub(-3) ~= ".md" then return false end

  local ok, slug = pcall(function() return require("hive.workbench").actions.fn() end)
  if not ok or not slug then return false end

  local workbench_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "workbenches")
  local prefix = vim.fs.normalize(vim.fs.joinpath(workbench_dir, slug .. "-"))
  return vim.startswith(vim.fs.normalize(name), prefix)
end

local function chat()
  local err = require("hive.agent").chat()
  if err then vim.notify("Hive: " .. err, vim.log.levels.ERROR) end
end

local function override_keymap()
  if not overridden then
    original_map = vim.fn.maparg("<leader>p", "n", false, true)
    overridden = true
  end
  vim.keymap.set("n", "<leader>p", chat, { desc = "Send the workbench to the agent" })
end

local function restore_keymap()
  if not overridden then return end

  if original_map and not vim.tbl_isempty(original_map) then
    vim.fn.mapset("n", false, original_map)
  else
    pcall(vim.keymap.del, "n", "<leader>p")
  end

  original_map = nil
  overridden = false
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
  group = workbench_group,
  callback = function(ev)
    -- The keymap is global, so only follow the buffer shown in the current window.
    if ev.buf ~= vim.api.nvim_get_current_buf() then return end

    if is_current_workbench(ev.buf) then
      override_keymap()
    else
      restore_keymap()
    end
  end,
})
