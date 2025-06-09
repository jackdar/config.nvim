return {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  priority = 1000,
  config = function()
    require('rose-pine').setup({
        disable_background = true,
        styles = {
          italic = false,
          transparency = true,
        },
    })

    vim.cmd("colorscheme rose-pine")
  end
}
