-- [[ Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Set `number` and `relativenumber` to false when opening a terminals
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Disable line numbering on terminal open',
  group = vim.api.nvim_create_augroup('termopen', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Disable auto comment continuation
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.cmd 'set formatoptions-=ro'
  end,
})
