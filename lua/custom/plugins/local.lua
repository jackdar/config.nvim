return {
  {
    dir = "~/plugins/sykes.nvim",
    event = "VeryLazy",
    config = function()
      require("sykes").setup()
    end,
  },
  {
    dir = "~/plugins/nvim-tabline",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "TabNew" },
    config = function()
      require("tabline").setup {
        show_icon = true,
        show_index = false,
        brackets = { "", "" },
      }
    end,
  },
  -- {
  --   dir = "~/plugins/prettier-helpers",
  --   event = "BufReadPre",
  --   config = function()
  --     require("prettier_helpers").setup()
  --   end,
  -- },
}
