-- [[ Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Set `number` and `relativenumber` to false when opening a terminals
vim.api.nvim_create_autocmd("TermOpen", {
  desc = "Disable line numbering on terminal open",
  group = vim.api.nvim_create_augroup("termopen", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Check and apply globals
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd "set number"

    -- Expand comments
    if vim.g.EXPANDCOMMENTS then
      vim.cmd "set formatoptions-="
    else
      vim.cmd "set formatoptions-=ro"
    end

    -- Set relative line numbers
    if vim.g.RELATIVENUMBER then
      vim.cmd "set relativenumber"
    else
      vim.cmd "set norelativenumber"
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function(args)
    vim.wo.wrap = true
  end,
})
