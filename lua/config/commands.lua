--- Custom Commands
vim.api.nvim_create_user_command("Scratch", require("utils.scratch").scratch, {})

-- Run and append
vim.api.nvim_create_user_command("Run", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("^(%s*)%$%s?", "%1")
  end

  require("utils.insert").cmd_output(table.concat(lines, "\n"), nil, opts.line2)
end, { range = true })

-- Render the mermaid definition at the cursor, or in the range, into <cwd>/diagram-<n>.svg
vim.api.nvim_create_user_command("Mermaid", function(opts)
  if vim.fn.executable("mmdc") ~= 1 then
    vim.notify("mmdc (mermaid-cli) is not installed", vim.log.levels.ERROR)
    return
  end

  local lines

  -- No range means the cursor, so render the fenced block it sits in.
  if opts.range == 0 then
    lines = require("utils.mermaid").fence_lines(0, vim.api.nvim_win_get_cursor(0))
  end
  lines = lines or vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  local n, out = 0, nil
  repeat
    n = n + 1
    out = string.format("diagram-%d.svg", n)
  until vim.fn.filereadable(out) == 0

  local result = vim.system(
    { "mmdc", "--input", "-", "--output", out },
    { text = true, stdin = table.concat(lines, "\n") }
  ):wait()

  if result.code ~= 0 then
    vim.notify((result.stderr or result.stdout or "mmdc failed"):gsub("\n$", ""), vim.log.levels.ERROR)
    return
  end

  vim.notify("Mermaid diagram written to " .. vim.fn.getcwd() .. "/" .. out)
end, { range = true, desc = "Render the fenced mermaid block at the cursor, or the range, to an SVG" })

-- Pipe into command
vim.api.nvim_create_user_command("Pipe", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  require("utils.insert").cmd_output(opts.args, lines, opts.line2)
end, { range = true, nargs = "+", complete = "shellcmd" })

vim.api.nvim_create_user_command("Reload", function(opts)
  local module_name = opts.args
  package.loaded[module_name] = nil
  require(module_name)
end, { nargs = 1 })

vim.api.nvim_create_user_command(
  "TelescopeVisualGrep",
  function() require("utils.telescope_selection").telescope_visual_grep() end,
  { range = true }
)

-- Find files in the current west workspace, including projects ignored by the
-- top-level .gitignore, or fall back to a regular find if there is no manifest.
vim.api.nvim_create_user_command("WestFindFiles", function()
  local builtin = require("telescope.builtin")
  local find_command = { "rg", "--iglob", "!.git", "--hidden", "--files" }
  local manifest = vim.fn.getcwd() .. "/manifest/west.yml"

  if vim.fn.filereadable(manifest) == 0 or vim.fn.executable("yq") ~= 1 then
    builtin.find_files({ find_command = find_command })
    return
  end

  local output = vim.system({ "yq", "-r", ".manifest.projects[] | .path // .name", manifest }, { text = true }):wait()

  local search_dirs = { "." }
  local seen = { ["."] = true }
  if output.code == 0 then
    for _, path in ipairs(vim.split(vim.trim(output.stdout or ""), "\n", { trimempty = true })) do
      path = vim.trim(path)
      if path ~= "" and not seen[path] and vim.fn.isdirectory(path) == 1 then
        seen[path] = true
        table.insert(search_dirs, path)
      end
    end
  end

  builtin.find_files({ find_command = find_command, search_dirs = search_dirs })
end, { desc = "Find files in a west workspace" })

-- Insert an empty markdown table of <col> columns, a header and <row> body rows
vim.api.nvim_create_user_command("Table", function(opts)
  local cols, rows = tonumber(opts.fargs[1]), tonumber(opts.fargs[2])
  if not cols or not rows or cols < 1 or rows < 0 then
    vim.notify("Usage: Table <col> <row>", vim.log.levels.ERROR)
    return
  end

  local empty = "|" .. string.rep("     |", cols)
  local lines = { empty, "|" .. string.rep(" --- |", cols) }
  for _ = 1, rows do
    table.insert(lines, empty)
  end

  vim.api.nvim_put(lines, "l", true, false)
end, { nargs = "+", desc = "Insert a markdown table" })

vim.api.nvim_create_user_command(
  "BackspaceSubword",
  function() vim.cmd.normal({ require("utils.subword").normal_keys(), bang = true }) end,
  { desc = "Delete the subword before the cursor" }
)
