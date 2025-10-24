vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.cmd "compiler tsc"
vim.bo.makeprg = "npx tsc --noEmit"
