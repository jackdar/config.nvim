return {
  {
    "echasnovski/mini.nvim",
    event = "InsertEnter",
    -- dependencies = {
    --   { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
    -- },
    config = function()
      require("mini.ai").setup { n_lines = 500 }
      require("mini.surround").setup()
      -- require("mini.comment").setup {
      --   options = {
      --     custom_commentstring = function()
      --       return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
      --     end,
      --   },
      -- }
    end,
  },
}
