return { -- LSP Plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      -- Allows extra capabilities provided by nvim-cmp
      'hrsh7th/cmp-nvim-lsp',
      -- Schema information
      'b0o/SchemaStore.nvim',
    },
    config = function()
      local default_handlers = {
        ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
        ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
      }
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require 'telescope.builtin'

          map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
          map('gr', builtin.lsp_references, '[G]oto [R]eferences')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gT', builtin.lsp_type_definitions, 'Type [D]efinition')
          map('K', vim.lsp.buf.hover, 'Hover')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('<leader>wd', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        intelephense = {
          filetypes = { 'php', 'blade' },
        },
        gopls = {},
        ts_ls = {},
        html = {
          filetypes = { 'html', 'blade' },
        },
        cssls = {},
        tailwindcss = {},
        sqls = {},
        clangd = {
          filetypes = { 'c', 'h', 'cpp', 'hpp' },
        },
        zls = {
          filetypes = { 'zig' },
        },
        dockerls = {
          filetypes = { 'Dockerfile', 'dockerfile' },
        },
        docker_compose_language_service = {
          filetypes = { 'yaml.docker-compose', 'yml.docker-compose' },
        },
        lua_ls = {
          handlers = default_handlers,
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'prettierd',
        'goimports-reviser',
        'sqlfmt',
        -- 'eslint_d',
        'clang-format',
        'php-cs-fixer',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
        automatic_enable = {
          exclude = {
            'rust_analyzer',
            'phpactor',
          },
        },
      }

      vim.diagnostic.config { virtual_text = true, virtual_lines = false }

      -- Enable PHP Actor for code actions and disable other capabilities
      require('lspconfig').phpactor.setup {
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
          ['language_server.diagnostics_on_update'] = false,
          ['language_server.diagnostics_on_open'] = false,
          ['language_server.diagnostics_on_save'] = false,
          ['language_server_phpstan.enabled'] = false,
          ['language_server_psalm.enabled'] = false,
          ['language_server_php_cs_fixer.enabled'] = false,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
