return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        styles = {
          italic = false,
          transparency = true,
        },
        highlight_groups = {
          WinBar = { bg = "none" },
        },
      }

      vim.cmd.colorscheme "rose-pine"
    end,
  },
  {
    "drewxs/ash.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("ash").setup {
        transparent = true,
        term_colors = true,
      }

      -- vim.cmd.colorscheme "ash"
    end,
  },
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup {
        overrides = {
          Normal = { bg = "None" },
          NormalFloat = { bg = "none" },
          ColorColumn = { bg = "None" },
          SignColumn = { bg = "None" },
          Folded = { bg = "None" },
          FoldColumn = { bg = "None" },
          CursorLine = { bg = "None" },
          CursorColumn = { bg = "None" },
          VertSplit = { bg = "None" },
        },
      }

      -- vim.cmd.colorscheme "ayu"
    end,
  },
}
