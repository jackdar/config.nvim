-- [[ Completions Configuration ]]
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.shortmess:append 'c'

local luasnip = require 'luasnip'
luasnip.config.setup {}

require('tailwindcss-colorizer-cmp').setup {
  color_square_width = 2,
}

require('copilot_cmp').setup()
local cmp = require 'cmp'

cmp.setup {
  sources = {
    { name = 'copilot', group_index = 2 },
    {
      name = 'lazydev',
      group_index = 0,
    },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },

  completion = {
    completeopt = 'menu,menuone,noinsert',
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(), -- Select the [n]ext item
    ['<C-p>'] = cmp.mapping.select_prev_item(), -- Select the [p]revious item

    -- Scroll the documentation window [b]ack / [f]orward
    ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-y>'] = cmp.mapping.confirm { select = true }, -- Accept ([y]es) the completion.

    -- ['<CR>'] = cmp.mapping.confirm { select = true },
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),

    ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger a completion from nvim-cmp.

    ['<C-d>'] = function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,

    ['<C-l>'] = cmp.mapping(function()
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { 'i', 's' }),
    ['<C-h>'] = cmp.mapping(function()
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { 'i', 's' }),
  },

  cmp.setup.filetype({ 'sql' }, {
    sources = {
      { name = 'vim-dadbod-completion' },
      { name = 'buffer' },
    },
  }),

  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  experimental = {
    ghost_text = false,
  },
}
