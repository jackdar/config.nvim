return {
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DB',
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  config = function()
    require('vim-dadbod').setup {
      auto_execute = true,
      auto_execute_delay = 0,
      auto_execute_silent = false,
      auto_execute_ignore_filetypes = { 'sql', 'mysql', 'plsql' },
    }
  end,
}
