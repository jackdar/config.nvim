return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
              -- require("luasnip.loaders.from_lua").lazy_load { paths = { "~/.config/nvim/lua/snippets" } }
            end,
          },
        },
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "zbirenbaum/copilot.lua",
        event = { "VeryLazy" },
        dependencies = {
          "fang2hou/blink-copilot",
        },
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
          copilot_node_command = vim.fn.expand "~/.local/share/fnm/aliases/default/bin/node",
        },
      },
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
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
            auto_insert = false,
          },
        },
        -- accept = {
        --   auto_brackets = {
        --     enabled = true,
        --   },
        -- },
      },
      sources = {
        default = { "lsp", "path", "snippets", "lazydev", "buffer", "copilot" },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
          mysql = { "snippets", "dadbod", "buffer" },
        },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 200,
            async = true,
          },
          dadbod = { name = "SQL", module = "vim_dadbod_completion.blink" },
        },
      },
      -- snippets = { preset = "luasnip" },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      -- enabled = function()
      --   return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
      -- end,
    },
  },
}
