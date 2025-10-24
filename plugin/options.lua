-- [[ Options ]]
vim.o.inccommand = "split"
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.number = true
vim.o.relativenumber = vim.g.RELATIVENUMBER

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.scrolloff = 4
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.termguicolors = true
vim.o.signcolumn = "yes"
-- vim.o.colorcolumn = "120"

vim.o.wrap = false
vim.o.linebreak = true
vim.o.smartindent = false
vim.o.autoindent = false

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.foldmethod = "manual"

vim.o.updatetime = 250
vim.o.timeoutlen = 300

if vim.fn.executable "rg" == 1 then
  vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
  vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m,%f"
end
