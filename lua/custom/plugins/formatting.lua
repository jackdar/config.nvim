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
    }
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = require('config.conform')
}
