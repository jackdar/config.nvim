return {
  {
    "tpope/vim-fugitive",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    event = "VeryLazy",
    keys = {
      { "<leader>G", "<cmd>tab Git<CR>" },
      { "<leader>ga", "<cmd>Git add %:p<CR>" },
      { "<leader>gs", "<cmd>G<CR>" },
      { "<leader>gt", "<cmd>Git commit -v -q %:p<CR>" },
      { "<leader>gd", "<cmd>Gdiff<CR>" },
      { "<leader>ge", "<cmd>Gedit<CR>" },
      { "<leader>gr", "<cmd>Gread<CR>" },
      { "<leader>gr", "<cmd>Gread<CR>" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = require "config.gitsigns",
  },
}
