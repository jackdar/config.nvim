return {
  {
    "jackdar/rose-pine-neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        disable_background = true,
        highlight_groups = {
          WinBar = { bg = "none" },
          StatusLine = { bg = "none" },
        },
      }
      vim.cmd.colorscheme "rose-pine"
    end,
  },
  -- {
  --   "nyoom-engineering/oxocarbon.nvim",
  --   name = "oxocarbon",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.opt.background = "dark"
  --     vim.cmd.colorscheme "oxocarbon"
  --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "LineNr", { fg = "#FFFFFF", bg = "none" })
  --     vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFFFF", bg = "none", bold = true })
  --     -- Neovim 0.10+: style relative numbers above/below separately
  --     vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5C6370", bg = "none" })
  --     vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#5C6370", bg = "none" })
  --   end,
  -- },
  -- {
  --   "AlexvZyl/nordic.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("nordic").load {
  --       transparent_bg = true,
  --     }
  --   end,
  -- },
  -- {
  --   "drewxs/ash.nvim",
  --   name = "ash",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("ash").setup {
  --       transparent = true,
  --       term_colors = true,
  --     }
  --     vim.cmd.colorscheme "ash"
  --   end,
  -- },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup {
  --       flavour = "mocha",
  --       background = {
  --         light = "latte",
  --         dark = "mocha",
  --       },
  --     }
  --     vim.cmd.colorscheme "catppuccin"
  --   end,
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   name = "tokyonight",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("tokyonight").setup {
  --       style = "moon",
  --       transparent = true,
  --     }
  --     vim.cmd.colorscheme "tokyonight"
  --   end,
  -- },
  -- {
  --   "vague2k/vague.nvim",
  --   name = "vague",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("vague").setup {
  --       transparent = true,
  --     }
  --     vim.cmd.colorscheme "vague"
  --   end,
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   name = "gruvbox",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup {
  --       transparent_mode = true,
  --     }
  --     vim.cmd.colorscheme "gruvbox"
  --   end,
  -- },
}
