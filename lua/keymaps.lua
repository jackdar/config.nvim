-- [[ Keymaps ]]
local set = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear highlights on search when pressing <Esc> in normal mode
set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Quick save the current buffer with no auto commands
set('n', '<leader>w', ':noautocmd w %<CR>', opts)

-- Move command to move lines in visual mode
set('v', 'J', ":m '>+1<CR>gv=gv", opts)
set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Keep the cursor in the same place when joining lines
set('n', 'J', 'mzJ`z', opts)

-- Diagnostic keymaps
set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })
set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

-- Open diagnostics floating window
set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })

-- Open current diagnostics in quick fix list
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Make executable
set('n', '<leader>x', ':!chmod +x %<CR>', opts)

-- Source current lua file
set('n', '<leader><leader>x', ':source %<CR>', opts)

-- Vertical scroll and center
set('n', '<C-d>', '<C-d>zz', opts)
set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
set('n', 'n', 'nzzzv', opts)
set('n', 'N', 'Nzzzv')

-- Keep last yanked when pasting
set('x', '<leader>p', '"_dP', opts)

-- Yank into system clipboard
set({ 'n', 'v' }, '<leader>y', '"+y', opts)
set('n', '<leader>Y', '"+Y', opts)

-- Yank the contents of the whole buffer
set('n', 'YY', ':%y<CR>', opts)

-- Stay in visual mode after indenting
set('v', '<', '<gv', opts)
set('v', '>', '>gv', opts)

-- Toggle line wrapping
set('n', '<leader>lw', '<cmd> set wrap!<CR>', opts)

-- Set keymaps for buffer management
set('n', '<leader>bd', ':bd!<CR>', opts)
set('n', '<leader>bc', '<cmd> enew <CR>', opts)

-- Toggle find and replace for the word under the cursor in the current buffer
set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', opts)
set('v', '<leader>s', 'y:%s/\\V<C-r>"/<C-r>"/gI<Left><Left><Left>', opts)

-- Toggle find and replace, deleting the word under the cursor in the current buffer.
set('n', '<leader>sd', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', opts)
set('v', '<leader>sd', 'y:%s/\\V<C-r>"//gI<Left><Left><Left>', opts)

-- Exit terminal mode in the builtin terminal
set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Open a new terminal buffer below in a horizontal split
set('n', '<leader>t', function()
  vim.cmd.new()
  vim.cmd.term()
  vim.cmd.startinsert()
  vim.api.nvim_win_set_height(0, 15)
end, opts)

-- Open a new terminal buffer to the right in a vertical split
set('n', '<leader>tv', function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.startinsert()
  vim.api.nvim_win_set_width(0, 40)
end, opts)

-- Run make build quickly
set('n', '<leader>m', ':make run<CR>', opts)
set('n', '<leader>M', ':make build<CR>', opts)

-- Insert contents of named register literally
set('i', '<C-r>', '<C-r><C-o>', opts)

-- Toggle relative line numbering
set('n', '<leader>ln', '<cmd>ToggleRl<CR>', opts)
