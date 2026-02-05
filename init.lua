vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.db_ui_use_nerd_fonts = 1
vim.g.vim_dadbod_completion_mark = ''

vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.mouse = 'a'
vim.o.breakindent = true
vim.o.wrap = false
vim.o.signcolumn = 'yes'
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.undofile = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = 'split'
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.confirm = true

vim.keymap.set('n', '<leader>w', ':noautocmd w %<CR>')

vim.keymap.set('i', '<s-<Up>>', '')
vim.keymap.set('i', '<s-<Down>>', '')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>qf', vim.diagnostic.setqflist)
vim.keymap.set('n', ']q', '<cmd>cnext<CR>')
vim.keymap.set('n', '[q', '<cmd>cprev<CR>')

vim.keymap.set('x', '<leader>p', '"_dP')
vim.keymap.set({ 'n', 'x' }, '<leader>d', '"_d')
vim.keymap.set({ 'n', 'x' }, '<leader>y', '"+y')

vim.keymap.set('n', '<M-,>', '<c-w>5<')
vim.keymap.set('n', '<M-.>', '<c-w>5>')
vim.keymap.set('n', '<M-t>', '<C-W>+')
vim.keymap.set('n', '<M-s>', '<C-W>-')

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<leader>ms', '<cmd>!npx cdk synth<CR>')

vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
vim.keymap.set('v', '<leader>s', 'y:%s/\\V<C-r>"/<C-r>"/gI<Left><Left><Left>')

vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
}

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

vim.api.nvim_create_user_command('Test', function()
  local file = vim.fn.expand '%:p'
  if not file:match '%.test%.tsx?$' then
    print 'Not a valid *.test.ts(x) file'
    return
  end
  vim.cmd('belowright 15sp | term npx vitest run --no-coverage ' .. vim.fn.shellescape(file))
  vim.api.nvim_feedkeys('i', 'n', false)
end, { nargs = 0 })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    'tpope/vim-vinegar',
    'tpope/vim-abolish',
    {
      'ThePrimeagen/harpoon',
      branch = 'harpoon2',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local harpoon = require 'harpoon'
        harpoon:setup()

        vim.keymap.set('n', '<leader>a', function()
          harpoon:list():add()
        end)
        vim.keymap.set('n', '<C-h>', function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end)
        vim.keymap.set('n', '<C-j>', function()
          harpoon:list():select(1)
        end)
        vim.keymap.set('n', '<C-k>', function()
          harpoon:list():select(2)
        end)
        vim.keymap.set('n', '<C-l>', function()
          harpoon:list():select(3)
        end)
        vim.keymap.set('n', '<C-;>', function()
          harpoon:list():select(4)
        end)
        vim.keymap.set('n', '<C-S-P>', function()
          harpoon:list():prev()
        end)
        vim.keymap.set('n', '<C-S-N>', function()
          harpoon:list():next()
        end)
      end,
    },
    {
      'tpope/vim-fugitive',
      dependencies = {
        'tpope/vim-rhubarb',
      },
      event = 'VeryLazy',
      config = function()
        local function rebase_branch()
          local branches = vim.fn.systemlist 'git branch --list'

          for i, branch in ipairs(branches) do
            branches[i] = branch:match '^%s*(.-)%s*$'
          end

          if branches == nil then
            print 'No branches found'
            return
          end

          if vim.tbl_contains(branches, 'master') then
            vim.cmd 'G rebase master'
          elseif vim.tbl_contains(branches, 'main') then
            vim.cmd 'G rebase main'
          elseif vim.tbl_contains(branches, 'development') then
            vim.cmd 'G rebase development'
          else
            local input = vim.fn.input 'Rebase onto branch: '
            vim.cmd('G rebase ' .. input)
          end
        end

        vim.keymap.set('n', '<leader>G', '<cmd>tab Git<CR>')
        vim.keymap.set('n', '<leader>gs', '<cmd>Git<CR>')
        vim.keymap.set('n', '<leader>ga', '<cmd>Git add %:p<CR>')
        vim.keymap.set('n', '<leader>gt', '<cmd>Git commit -v -q %:p<CR>')
        vim.keymap.set('n', '<leader>gd', '<cmd>Gvdiff HEAD<CR>')
        vim.keymap.set('n', '<leader>gc', '<cmd>G checkout -<CR>')
        vim.keymap.set('n', '<leader>gC', '<cmd>G checkout master<CR>')
        vim.keymap.set('n', '<leader>gb', ':G checkout -b ')
        vim.keymap.set('n', '<leader>gb', ':G checkout -b ')
        vim.keymap.set('n', '<leader>gl', '<cmd>Git pull<CR>')
        vim.keymap.set('n', '<leader>gp', '<cmd>Git push origin HEAD<CR>')
        vim.keymap.set('n', '<leader>gP', '<cmd>Git push origin HEAD --force<CR>')
        vim.keymap.set('n', '<leader>gB', function()
          rebase_branch()
        end)
      end,
    },
    { 'NMAC427/guess-indent.nvim', opts = {} },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = 'markdown',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
      opts = {
        render_modes = { 'n', 'c', 't' },
      },
    },
    {
      'lewis6991/gitsigns.nvim',
      event = 'BufReadPre',
      opts = {
        on_attach = function()
          local gitsigns = require 'gitsigns'

          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gitsigns.nav_hunk 'next'
            end
          end, { desc = 'Jump to next git [c]hange' })

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gitsigns.nav_hunk 'prev'
            end
          end, { desc = 'Jump to previous git [c]hange' })

          vim.keymap.set('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'stage git hunk' })
          vim.keymap.set('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'reset git hunk' })

          vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
          vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
          vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
          vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
          vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
          vim.keymap.set('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
          vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
          vim.keymap.set('n', '<leader>hD', function()
            gitsigns.diffthis '@'
          end, { desc = 'git [D]iff against last commit' })

          vim.keymap.set(
            'n',
            '<leader>tb',
            gitsigns.toggle_current_line_blame,
            { desc = '[t]oggle git show [b]lame line' }
          )
          vim.keymap.set('n', '<leader>td', gitsigns.preview_hunk_inline, { desc = '[t]oggle git show [d]eleted' })
        end,
      },
    },
    {
      'kristijanhusak/vim-dadbod-ui',
      dependencies = {
        'tpope/vim-dadbod',
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
      },
      cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    {
      'jackdar/rose-pine-neovim',
      name = 'rose-pine',
      lazy = false,
      priority = 1000,
      config = function()
        require('rose-pine').setup {
          disable_background = true,
        }
        vim.cmd.colorscheme 'rose-pine'
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      event = 'vimenter',
      version = '*',
      dependencies = {
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        require('telescope').setup {
          defaults = {
            mappings = {
              i = {
                ['<c-enter>'] = 'to_fuzzy_refine',
                ['<esc>'] = require('telescope.actions').close,
              },
            },
          },
          layout_strategy = 'flex',
          path_display = { 'truncate' },
          pickers = {
            live_grep = {
              additional_args = { '--hidden' },
            },
            find_files = {
              find_command = { 'fd', '--type=file', '--hidden' },
            },
          },
          extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown() },
          },
        }
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>fh', builtin.help_tags)
        vim.keymap.set('n', '<leader>fk', builtin.keymaps)
        vim.keymap.set('n', '<leader>ff', builtin.find_files)
        vim.keymap.set('n', '<leader>fs', builtin.builtin)
        vim.keymap.set({ 'n', 'v' }, '<leader>fw', builtin.grep_string)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep)
        vim.keymap.set('n', '<leader>fd', builtin.diagnostics)
        vim.keymap.set('n', '<leader>fr', builtin.resume)
        vim.keymap.set('n', '<leader>f.', builtin.oldfiles)
        vim.keymap.set('n', '<leader>fc', builtin.commands)
        vim.keymap.set('n', '<leader><leader>', builtin.buffers)

        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
          callback = function(event)
            local buf = event.buf
            vim.keymap.set('n', 'gr', builtin.lsp_references)
            vim.keymap.set('n', 'gi', builtin.lsp_implementations)
            vim.keymap.set('n', 'gd', builtin.lsp_definitions)
            vim.keymap.set('n', 'gs', builtin.lsp_document_symbols)
            vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols)
            vim.keymap.set('n', 'gD', builtin.lsp_type_definitions)
          end,
        })

        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end)

        vim.keymap.set('n', '<leader>fn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end)
      end,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'mason-org/mason.nvim', opts = {} },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'saghen/blink.cmp',
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
          callback = function(event)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
            vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action)
            vim.keymap.set('n', '<leader>gD', vim.lsp.buf.declaration)

            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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
            if client and client:supports_method('textDocument/inlayHint', event.buf) then
              vim.keymap.set('n', '<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end)
            end
          end,
        })

        local servers = {
          lua_ls = {},
          tsgo = {},
          astro = {},
          tailwindcss = {},
          sqls = {},
          intelephense = {},
          rust_analyzer = {},
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua',
          'prettierd',
          'prettier',
        })

        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        local capabilities = require('blink.cmp').get_lsp_capabilities()

        for name, server in pairs(servers) do
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          vim.lsp.config(name, server)
          vim.lsp.enable(name)
        end

        vim.lsp.config('lua_ls', {
          on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath 'config'
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = { 'lua/?.lua', 'lua/?/init.lua' },
              },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true),
              },
            })
          end,
          settings = {
            Lua = {},
          },
        })
        vim.lsp.enable 'lua_ls'
      end,
    },
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>f',
          function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end,
          mode = '',
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = false,
        format_after_save = function(bufnr)
          local disable_filetypes = { sql = true, c = true, cpp = true, php = true }
          if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
          else
            return {
              timeout_ms = 500,
              lsp_format = 'fallback',
            }
          end
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          typescript = { 'prettierd', 'prettier', stop_after_first = true },
          javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          json = { 'prettierd', 'prettier', stop_after_first = true },
          astro = { 'prettierd', 'prettier', stop_after_first = true },
        },
      },
    },
    {
      'saghen/blink.cmp',
      event = 'VimEnter',
      version = '1.*',
      dependencies = {
        {
          'L3MON4D3/LuaSnip',
          version = '2.*',
          build = (function()
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = {
            {
              'rafamadriz/friendly-snippets',
              config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
              end,
            },
          },
          opts = {},
        },
        {
          'zbirenbaum/copilot.lua',
          cmd = 'Copilot',
          event = 'InsertEnter',
          config = function()
            require('copilot').setup {
              suggestion = { enabled = false },
              panel = { enabled = false },
              copilot_node_command = vim.fn.expand '~/.local/share/fnm/aliases/default/bin/node',
            }
            vim.keymap.set('n', '<leader>cp', '<cmd>Copilot toggle<CR>')
          end,
        },
        { 'giuxtaposition/blink-cmp-copilot' },
      },
      --- @module 'blink.cmp'
      --- @type blink.cmp.Config
      opts = {
        keymap = { preset = 'default' },
        appearance = {
          nerd_font_variant = 'mono',
        },
        completion = {
          documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'copilot' },
          per_filetype = {
            sql = { 'snippets', 'dadbod', 'buffer' },
            mysql = { 'snippets', 'dadbod', 'buffer' },
          },
          providers = {
            copilot = {
              name = 'copilot',
              module = 'blink-cmp-copilot',
              score_offset = 100,
              async = true,
            },
            dadbod = {
              name = 'Dadbod',
              module = 'vim_dadbod_completion.blink',
            },
          },
        },
        snippets = { preset = 'luasnip' },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        signature = { enabled = true },
      },
    },
    {
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = { signs = false },
    },
    {
      'nvim-mini/mini.nvim',
      config = function()
        require('mini.ai').setup { n_lines = 500 }
        require('mini.surround').setup()
        require('mini.comment').setup()
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        local filetypes = {
          astro = 'astro',
          bash = 'bash',
          c = 'c',
          diff = 'diff',
          html = 'html',
          json = 'json',
          lua = 'lua',
          luadoc = 'luadoc',
          markdown = 'markdown',
          markdown_inline = 'markdown_inline',
          query = 'query',
          vim = 'vim',
          vimdoc = 'vimdoc',
          javascript = 'javascript',
          typescript = 'typescript',
          gitignore = 'gitignore',
          gitcommit = 'gitcommit',
          jsx = 'javascriptreact',
          tsx = 'typescriptreact',
          yaml = 'yaml',
          toml = 'toml',
          php = 'php',
          rust = 'rust',
        }

        require('nvim-treesitter').install(vim.tbl_keys(filetypes))
        vim.api.nvim_create_autocmd('FileType', {
          pattern = vim.tbl_values(filetypes),
          callback = function()
            vim.treesitter.start()
          end,
        })
      end,
    },
  },
  checker = { enabled = true },
}
