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

-- Sync Copilot state with saved global variable
vim.api.nvim_create_autocmd('InsertEnter', {
  desc = 'Set Copilot to persisted state',
  callback = function()
    local status = vim.g.copilot_enabled and 'enable' or 'disable'
    vim.cmd('silent! Copilot ' .. status)
  end,
})

-- Disable auto comment continuation
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.cmd 'set formatoptions-=ro'
  end,
})
