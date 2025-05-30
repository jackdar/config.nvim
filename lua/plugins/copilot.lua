return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      enabled = vim.g.copilot_enabled,
      suggestion = {
        enabled = false,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      filetypes = {
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        -- svn = false,
        -- cvs = false,
        -- ['.'] = false,
      },
    }

    vim.api.nvim_create_user_command('ToggleCopilot', function()
      require('state').set('copilot_enabled', not vim.g.copilot_enabled)

      local status = vim.g.copilot_enabled and 'enable' or 'disable'
      vim.cmd('silent! Copilot ' .. status)
      vim.notify('Copilot suggestions ' .. status, vim.log.levels.INFO)
    end, { desc = 'Toggle Copilot suggestions on/off' })

    vim.keymap.set('n', '<F10>', '<cmd>ToggleCopilot<CR>')
  end,
}
