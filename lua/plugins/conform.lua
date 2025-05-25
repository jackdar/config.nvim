return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true }
      end,
      desc = '[F]ormat buffer',
    },
    {
      '<leader>F',
      vim.cmd.ToggleFormat,
      desc = 'Toggle [F]ormat',
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      go = { 'goimports-reviser' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      html = { 'prettierd' },
      css = { 'prettierd' },
      json = { 'prettierd' },
      bash = { 'shfmt' },
      sh = { 'shfmt' },
      sql = { 'sqlfmt' },
      blade = { 'blade-formatter' },
      rustfmt = { 'rust' },
      clang_format = { 'c', 'cpp', 'h', 'hpp' },
    },

    default_format_opts = {
      lsp_format = 'fallback',
    },

    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { 'sql', 'java' }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match '/node_modules/' then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,

    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

    vim.api.nvim_create_user_command('ToggleFormat', function()
      vim.g.disable_autoformat = not vim.g.disable_autoformat

      local status = vim.g.disable_autoformat and 'disabled' or 'enabled'
      vim.notify('Autoformatting ' .. status, vim.log.levels.INFO)
    end, {
      desc = 'Toggle autoformat-on-save on/off',
    })
  end,
}
