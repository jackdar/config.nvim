--- @module 'conform'
--- @type conform.setupOpts
return {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    go = { "goimports-reviser" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    javascriptreact = { "prettierd" },
    typescriptreact = { "prettierd" },
    html = { "prettierd" },
    css = { "prettierd" },
    json = { "prettierd" },
    bash = { "shfmt" },
    sh = { "shfmt" },
    zsh = { "shfmt" },
    blade = { "blade-formatter" },
    rustfmt = { "rust" },
  },

  default_format_opts = {
    lsp_format = "fallback",
  },

  format_on_save = function(bufnr)
    local ignore_filetypes = { "sql", "java" }
    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
      return
    end
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match "/node_modules/" then
      return
    end
    -- if vim.g.autoformat_enabled or vim.b[bufnr].autoformat_enabled then
    return { timeout_ms = 500, lsp_format = "fallback" }
    -- end
  end,

  formatters = {
    shfmt = {
      prepend_args = { "-i", "2" },
    },
  },
}
