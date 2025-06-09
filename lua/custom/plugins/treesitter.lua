return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPost',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'EmranMR/tree-sitter-blade',
    },
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = require('config.treesitter'),
  },
}
