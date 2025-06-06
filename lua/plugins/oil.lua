return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  config = function()
    require('oil').setup {
      columns = { 'icon' },
      keymaps = {
        ['<C-h>'] = false,
        ['<C-l>'] = false,
        ['<C-k>'] = false,
        ['<C-j>'] = false,
        ['\\'] = false,
      },
      view_options = {
        show_hidden = false,
        natural_order = true,
        is_hidden_file = function(name, _)
          return name == '..' or name == '.git'
        end,
      },
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
    }

    -- Open parent directory in current window
    vim.keymap.set('n', '<leader>e', '<CMD>Oil<CR>', { desc = 'Open [E]xplorer' })

    -- Open the project root directory in the current window
    vim.keymap.set('n', '<leader>E', "<CMD>lua vim.cmd('Oil' .. vim.fn.getcwd())<CR>", { desc = 'Open [E]xplorer in root' })
  end,
}
