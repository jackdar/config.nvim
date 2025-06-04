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
      local ignore_filetypes = { 'sql', 'java' }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      if not vim.g.auto_format or not vim.b[bufnr].auto_format then
        return
      end
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
      require('state').set('auto_format', not vim.g.auto_format)

      local status = vim.g.auto_format and 'enabled' or 'disabled'
      vim.notify('Autoformatting ' .. status, vim.log.levels.INFO)
    end, {
      desc = 'Toggle autoformat-on-save on/off',
    })
  end,
}
