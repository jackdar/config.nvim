return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      -- Better Around/Inside textobjects
      require("mini.ai").setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require("mini.surround").setup()

      -- Easily comment lines
      require("mini.comment").setup()
    end,
  },
}
