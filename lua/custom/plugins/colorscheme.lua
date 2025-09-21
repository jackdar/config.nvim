return {
  {
    "jackdar/rose-pine-neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        disable_background = true,
        highlight_groups = {
          WinBar = { bg = "none" },
        },
      }
      vim.cmd.colorscheme "rose-pine"
    end,
  },
  {
    "drewxs/ash.nvim",
    lazy = true,
    config = function()
      require("ash").setup {
        transparent = true,
        term_colors = true,
      }
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    config = function()
      require("catppuccin").setup {
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
      }
    end,
  },
}
