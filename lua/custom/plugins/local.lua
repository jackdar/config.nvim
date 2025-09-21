return {
  {
    dir = "~/plugins/sykes.nvim",
    cmd = "Test",
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
}
