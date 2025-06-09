return {
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb',
    },
    event = 'VeryLazy',
    keys = {
      { '<leader>G', '<CMD>tab Git<CR>' },
      { '<leader>ga', '<CMD>Git add %:p<CR>' },
      { '<leader>gs', '<CMD>G<CR>' },
      { '<leader>gt', '<CMD>Git commit -v -q %:p<CR>' },
      { '<leader>gd', '<CMD>Gdiff<CR>' },
      { '<leader>ge', '<CMD>Gedit<CR>' },
      { '<leader>gr', '<CMD>Gread<CR>' },
      { '<leader>gr', '<CMD>Gread<CR>' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = require 'config.gitsigns',
  },
}
