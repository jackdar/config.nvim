--- @module 'blink.cmp'
--- @type blink.cmp.Config
return {
  keymap = {
    preset = "default",
  },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "lazydev", "buffer", "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        score_offset = 100,
        async = true,
      },
      lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  snippets = { preset = "luasnip" },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
  enabled = function()
    return not vim.tbl_contains({ "markdown", "oil" }, vim.bo.filetype)
  end,
}
