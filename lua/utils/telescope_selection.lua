local M = {}

--- Get the current visual mode selection as text.
---
--- @return string selected text
function M.get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_row, start_col = start_pos[2] - 1, start_pos[3] - 1
  local end_row, end_col = end_pos[2] - 1, end_pos[3]

  local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)
  if #lines == 0 then return "" end

  if start_row == end_row then return string.sub(lines[1], start_col + 1, end_col) end

  lines[1] = string.sub(lines[1], start_col + 1)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  return table.concat(lines, "\n")
end

--- Search the current visual selection with telescope's grep.
function M.telescope_visual_grep()
  local search = get_visual_selection()
  if search == "" then return end
  require("telescope.builtin").live_grep({ default_text = search })
end

return M
