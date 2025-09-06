return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    -- Detect tabstop and shiftwidth automatically
    "tpope/vim-sleuth",
    event = "BufReadPre",
  },
  {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- { -- Insert indent lines
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   ft = { "javascript", "typescript", "jsx", "tsx", "html", "css", "scss", "json", "yaml", "markdown" },
  --   event = "BufReadPre",
  --   lazy = true,
  --   ---@module "ibl"
  --   ---@type ibl.config
  --   opts = {
  --     indent = { char = "▏" },
  --     scope = { show_start = false, show_end = false },
  --   },
  -- },
  { -- Autopair brackets and parenthesis
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    opts = {},
  },
  { -- Auto pair HTML and JSX tags
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "typescript", "jsx", "tsx", "html", "blade", "php", "xml" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  { -- Render markdown files nicely in Neovim
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    event = "BufReadPre",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c", "t" },
    },
  },
}
