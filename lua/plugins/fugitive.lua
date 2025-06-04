return {
  -- Powerful Git integration for Vim
  'tpope/vim-fugitive',
  config = function()
    local set = vim.keymap.set
    local opts = { noremap = true, silent = true }

    set('n', '<leader>G', ':tab Git<CR>', opts)
    set('n', '<leader>ga', ':Git add %:p<CR>', opts)
    set('n', '<leader>gs', ':G<CR>', opts)
    set('n', '<leader>gt', ':Git commit -v -q %:p<CR>', opts)
    set('n', '<leader>gd', ':Git diff<CR>', opts)
    set('n', '<leader>ge', ':Gedit<CR>', opts)
    set('n', '<leader>gr', ':Gread<CR>', opts)
    set('n', '<leader>gr', ':Gread<CR>', opts)
  end,
}
