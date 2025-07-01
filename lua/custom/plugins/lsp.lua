return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = { "VeryLazy" },
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
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "saghen/blink.cmp" },
      {
        "nvimdev/lspsaga.nvim",
        config = function()
          require("lspsaga").setup {
            lightbulb = {
              enable = false,
            },
          }
        end,
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-tree/nvim-web-devicons",
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
          map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
          map("gf", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has "nvim-0.11" == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
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

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        ts_ls = {},
        zls = {},
        graphql = {},
        jdtls = {
          init_options = {
            bundles = {
              vim.fn.glob(
                vim.fn.stdpath "data" .. "/mason/packages/jdtls-deps/plugins/org.eclipse.equinox.launcher_*.jar"
              ),
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "prettierd",
        "php-cs-fixer",
      })
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      require("mason-lspconfig").setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
        automatic_enable = {
          exclude = {
            "intelephense",
            "phpactor",
          },
        },
      }

      require("lspconfig").intelephense.setup {
        enable = true,
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          intelephense = {
            environment = {
              includePaths = { "**/vendor", "~/.config/composer/vendor/jetbrains/phpstorm-stubs/" },
            },
          },
        },
        root_dir = require("lspconfig").util.root_pattern(".git", "package.json", "composer.json"),
      }

      -- Enable PHP Actor for code actions and disable other capabilitiesAdd commentMore actions
      require("lspconfig").phpactor.setup {
        enable = true,
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.referencesProvider = false
          client.server_capabilities.definitionProvider = false
          client.server_capabilities.publishDiagnosticsProvider = false
          client.server_capabilities.inlineValueProvider = false
          client.server_capabilities.selectionRangeProvider = false
          client.server_capabilities.signatureHelpProvider = false
          client.server_capabilities.definitionsProvider = false
          client.server_capabilities.documentSymbolProvider = false
        end,
        init_options = {
          ["language_server.diagnostics_on_update"] = false,
          ["language_server.diagnostics_on_open"] = false,
          ["language_server.diagnostics_on_save"] = false,
          ["language_server_phpstan.enabled"] = false,
          ["language_server_psalm.enabled"] = false,
          ["language_server_php_cs_fixer.enabled"] = false,
        },
      }
    end,
  },
}
