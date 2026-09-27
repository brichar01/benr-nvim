--- Custom Commands

vim.api.nvim_create_user_command("Scratch", require("utils.scratch").scratch, {})

-- Run and append
vim.api.nvim_create_user_command("Run", function(opts)
  local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)

  require("utils.insert").cmd_output(table.concat(lines, "\n"), nil, opts.line2)
end, { range = true })

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
