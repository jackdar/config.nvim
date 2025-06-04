--[[ Initialise Neovim ]]

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('state').init()

-- [[ Setting options ]]
require 'options'

-- [[ Setting keymaps ]]
require 'keymaps'

-- [[ Setting auto commands ]]
require 'autocmds'

-- [[ Work: Bachcare ]]
require 'bachcare'

-- For mason.nvim, yet to find a better way to achieve this
vim.cmd("let $PATH = '" .. vim.g.node_host_prog .. ":' . $PATH")

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('error cloning lazy.nvim:\n' .. out)
  end
end

-- Add lazy to the `runntimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require('lazy').setup({
  { import = 'plugins' },
}, require 'config.lazy')

-- [[ Setting colorscheme ]]
vim.cmd.colorscheme(vim.g.colorscheme)
