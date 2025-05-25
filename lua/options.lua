-- [[ Options ]]
local opt = vim.opt

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
-- opt.showmode = true

-- Set highlight on search
opt.hlsearch = false

-- Set termguicolors to enable highlighting
opt.termguicolors = true

-- Sync clipboard between OS and Neo
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Don't use swapfiles
opt.swapfile = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = 'yes'

-- Decrease update time
opt.updatetime = 250

-- Decrease mapped sequence wait time
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Preview substitutions live
opt.inccommand = 'split'

-- Show which line your cursor is on
opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor
opt.scrolloff = 4

-- Disable text wrapping
opt.wrap = false

-- Set highlight on search
opt.hlsearch = false
opt.incsearch = true

-- Don't split words
opt.linebreak = true

-- The number of spaces inserted for each indentation (default: 8)
opt.shiftwidth = 4

-- Insert n spaces for a tab (default: 8)
opt.tabstop = 4

-- Number of spaces that a tab counts for while performing editing operations (default: 0)
opt.softtabstop = 4

-- Convert tabs to spaces (default: false)
opt.expandtab = true

-- Enable auto-indentation
-- opt.autoindent = true

-- Minimum number of screen columns either side of the cursor
opt.sidescrolloff = 8

-- Insert mode cursor as block
-- opt.guicursor = 'n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block-blinkoff400-blinkon250-Cursor/lCursor'
-- opt.guicursor = 'n-v-c-sm:block,ci-ve:ver25,r-cr-o:hor20,i:block'
vim.opt.guicursor = 'i:block-blinkwait0-blinkoff400-blinkon250'
-- opt.guicursor = ''

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s).
opt.confirm = true
