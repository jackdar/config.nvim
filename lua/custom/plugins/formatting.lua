return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format { async = true }
      end,
      desc = "[F]ormat buffer",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports-reviser" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      astro = { "prettier" },
      bash = { "shfmt" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      blade = { "blade-formatter" },
      rust = { "rustfmt" },
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
  },
}
