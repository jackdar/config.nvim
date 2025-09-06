--[[ Initialise Neovim ]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_list_hide = "^..=/=$,.DS_Store,.idea,\\.git,__pycache__,venv,node_modules,*.o,*.pyc,.*.swp"
vim.g.netrw_hide = 1

require "custom.lazy"
