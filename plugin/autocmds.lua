-- [[ Autocommands ]]
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
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

-- Disable line numbers for man pages
vim.api.nvim_create_autocmd("FileType", {
  pattern = "man",
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Check and apply globals
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    -- Skip for man pages
    if vim.bo.filetype == "man" then
      return
    end

    vim.cmd "set number"
    vim.cmd "set formatoptions-=ro"

    -- Set relative line numbers
    if vim.g.RELATIVENUMBER then
      vim.cmd "set relativenumber"
    else
      vim.cmd "set norelativenumber"
    end
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
    -- Skip for man pages
    if vim.bo.filetype == "man" then
      return
    end

    vim.cmd "set number"
    vim.cmd "set formatoptions-=ro"

    -- Set relative line numbers
    if vim.g.RELATIVENUMBER then
      vim.cmd "set relativenumber"
    else
      vim.cmd "set norelativenumber"
    end
  end,
})

-- Wrap text in Telescope previewer
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.wo.wrap = true
  end,
})

-- Automatically open the quickfix window if there are any entries
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("open_quickfix", { clear = true }),
  callback = function()
    vim.cmd "cwindow"
  end,
})

-- Trigger filetype detection when leaving Netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("netrw_filetype_detect", { clear = true }),
      callback = function()
        if vim.bo.filetype == "" then
          vim.cmd "filetype detect"
        end
      end,
    })
  end,
})

-- Detect filetype for newly created files
vim.api.nvim_create_autocmd("BufNewFile", {
  group = vim.api.nvim_create_augroup("new_file_filetype", { clear = true }),
  callback = function()
    vim.cmd "filetype detect"
  end,
})
