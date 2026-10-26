-- Customize Mason

---@type LazySpec
return {
  "mason-org/mason.nvim",
  -- Append so a project's dev shell tools, such as a pinned clang-format, win over Mason's.
  opts = { PATH = "append" },
}
