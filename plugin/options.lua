-- [[ Options ]]
local o = vim.o

o.inccommand = "split"
o.ignorecase = true
o.smartcase = true

o.number = true
o.relativenumber = vim.g.RELATIVENUMBER

o.splitbelow = true
o.splitright = true

o.signcolumn = "yes"

o.swapfile = false
o.backup = false
o.undofile = true

o.hlsearch = false
o.incsearch = true
o.termguicolors = true
o.background = "dark"
o.colorcolumn = "120"

o.wrap = false
o.linebreak = true
o.breakindent = true
o.smartindent = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.foldmethod = "manual"

o.updatetime = 250
o.timeoutlen = 300

o.scrolloff = 4
