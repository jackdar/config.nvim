return {
  "mason-org/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    {
      "neovim/nvim-lspconfig",
      dependencies = {
        {
          "folke/lazydev.nvim",
          ft = "lua",
          opts = {
            library = {
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
          },
        },
        { "j-hui/fidget.nvim", opts = {} },
      },
      config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("lsp-attach", {}),
          callback = function(args)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
            vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[G]oto Code [A]ction" })
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
            vim.keymap.set(
              "n",
              "gi",
              require("telescope.builtin").lsp_implementations,
              { desc = "[G]oto [I]mplementation" }
            )
            vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "[G]oto [D]efinition" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })
            vim.keymap.set(
              "n",
              "gO",
              require("telescope.builtin").lsp_document_symbols,
              { desc = "Open Document Symbols" }
            )
            vim.keymap.set(
              "n",
              "gW",
              require("telescope.builtin").lsp_dynamic_workspace_symbols,
              { desc = "Open Workspace Symbols" }
            )
            vim.keymap.set(
              "n",
              "gf",
              require("telescope.builtin").lsp_type_definitions,
              { desc = "[G]oto [T]ype Definition" }
            )

            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if client:supports_method("textDocument/documentHighlight", args.buf) then
              local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
              vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = args.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = args.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                callback = function(args2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = args2.buf }
                end,
              })
            end
          end,
        })

        vim.diagnostic.config {
          severity_sort = true,
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = "󰅚 ",
              [vim.diagnostic.severity.WARN] = "󰀪 ",
              [vim.diagnostic.severity.INFO] = "󰋽 ",
              [vim.diagnostic.severity.HINT] = "󰌶 ",
            },
          } or {},
          virtual_text = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }

        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                disable = { "missing-fields" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          },
        })

        require("mason-lspconfig").setup()
        require("mason-tool-installer").setup {
          ensure_installed = {
            "lua_ls",
            "stylua",
            "vtsls",
            "eslint-lsp",
            "prettierd",
            "shfmt",
            "rust-analyzer",
            "rustfmt",
            "gopls",
            "goimports-reviser",
            "phpactor",
            "blade-formatter",
          },
        }
      end,
    },
  },
}
