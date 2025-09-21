return {
  {
    "echasnovski/mini.nvim",
    event = "InsertEnter",
    config = function()
      require("mini.ai").setup { n_lines = 500 }
      require("mini.surround").setup()
      require("mini.comment").setup()
    end,
  },
}
