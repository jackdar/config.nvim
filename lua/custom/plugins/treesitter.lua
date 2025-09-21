return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = "BufReadPre",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "diff",
          "dockerfile",
          "editorconfig",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "graphql",
          "html",
          "java",
          "javadoc",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "php",
          "phpdoc",
          "python",
          "query",
          "regex",
          "rust",
          "sql",
          "ssh_config",
          "toml",
          "tsx",
          "typescript",
          "xml",
          "yaml",
          "zig",
        },
      }

      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
        pattern = "TSUpdate",
        callback = function()
          local parsers = require "nvim-treesitter.parsers"

          parsers.blade = {
            install_info = {
              url = "https://github.com/EmranMR/tree-sitter-blade",
              files = { "src/parser.c" },
              branch = "main",
            },
            file = "blade",
          }
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "BufReadPre",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    opts = {
      max_lines = 10,
    },
  },
}
