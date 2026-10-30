local M = {}

local SUBWORD_PATTERNS = {
  "%u?%l+[_%-%.%s]*$", -- Word in fooWord, word in a_word, a_ in a_, Server in HTTPServer
  "%u+[_%-%.%s]*$", -- HTTP in parseHTTP
  "%d+[_%-%.%s]*$",
  "[_%-%.%s]+$",
}

--- Number of characters in the subword before the cursor, at least 1.
---
--- A subword takes the separators (`_`, `-`, `.`, whitespace) after it, so
--- `a_word` and `a word` both backspace to `a_` or `a ` and then to nothing.
function M.length_before_cursor()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = vim.api.nvim_get_current_line():sub(1, col)
  for _, pattern in ipairs(SUBWORD_PATTERNS) do
    local match = before:match(pattern)
    if match then return vim.fn.strchars(match) end
  end
  return 1
end

--- Keys that delete the subword before the cursor in normal mode, without touching registers.
function M.normal_keys() return '"_' .. M.length_before_cursor() .. "X" end

return M
