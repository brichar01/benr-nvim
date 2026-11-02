local M = {}

--- Content lines of the fenced code block around `pos`, without the fences.
---
--- @param buf integer? buffer (0 or nil for the current buffer)
--- @param pos [integer, integer] cursor position from `nvim_win_get_cursor`
---
--- @return string[]? nil when `pos` is not inside a fenced code block
function M.fence_lines(buf, pos)
  buf = buf or 0

  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then
    return nil
  end
  parser:parse(true)

  local row, col = pos[1] - 1, pos[2]

  -- Leading whitespace belongs to no node inside the enclosing construct.
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
  local first = line:find("%S")
  if first and col < first - 1 then
    col = first - 1
  end

  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, col } })
  while node and node:type() ~= "fenced_code_block" do
    node = node:parent()
  end
  if not node then
    return nil
  end

  for child in node:iter_children() do
    if child:type() == "code_fence_content" then
      local start_r, _, end_r, end_c = child:range()
      if end_c == 0 then
        end_r = end_r - 1
      end
      return vim.api.nvim_buf_get_lines(buf, start_r, end_r + 1, false)
    end
  end
  return nil
end

return M
