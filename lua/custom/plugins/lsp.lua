return { -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'stevearc/conform.nvim', opts = {} }, -- Formatter
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
    -- Mason setup (kept as is)
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Installs tools based on `ensure_installed`
    -- Fidget status updates (kept as is)
    { 'j-hui/fidget.nvim', opts = {} },
    -- Completion Engine setup (kept as is)
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
      },
    },
  },
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black', 'isort', 'yapf', 'ruff' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      -- If this is set, Conform will run the formatter on save.
      -- It will pass the table to conform.format().
      -- This can also be a function that returns the table.
      format_on_save = {
        -- I recommend these options. See :help conform.format for details.
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
    }

    -- LspAttach autocommand (Existing)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          local effective_mode = mode or 'n' -- Default to 'n' if mode is nil
          if type(desc) == 'string' then
            vim.keymap.set(effective_mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          else
            vim.keymap.set(effective_mode, keys, func, { buffer = event.buf, desc = 'LSP: Action (Desc Error)' })
            print("Warning: Invalid 'desc' type passed to map for keys:", keys)
          end
        end

        map('gn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client:supports_method('textdocument/formatting', { bufnr = event.buf }) then
          -- correctly use vim.keymap.set(mode, lhs, rhs, opts)
          vim.keymap.set(
            { 'n', 'v' }, -- mode(s): normal and visual
            '<leader>f', -- lhs (left hand side): the key sequence to map
            function() -- rhs (right hand side): the action to perform
              vim.lsp.buf.format {
                async = true,
                timeout_ms = 2000,
                bufnr = event.buf, -- format the current buffer attached to the lsp
              }
            end,
            { -- opts: table of options for the keymap
              desc = 'format document (lsp)', -- description for which-key or other plugins
              noremap = true, -- non-recursive mapping
              silent = true, -- don't show the command in the command line
              buffer = event.buf, -- make this keymap buffer-local
            }
          )
          print('formatting keymap (<leader>f) set for buffer:', event.buf)
        else
          if not client then
            print('lsp client not found for client_id:', event.data.client_id, 'in buffer:', event.buf)
          else
            print('client for buffer', event.buf, 'does not support textdocument/formatting.')
          end
        end

        local function client_supports_method(client_instance, method, bufnr)
          if not client_instance then
            return false
          end
          if vim.fn.has 'nvim-0.11' == 1 then
            return client_instance:supports_method(method, { bufnr = bufnr })
          else
            return client_instance.supports_method and client_instance.supports_method(method, { bufnr = bufnr })
          end
        end

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd(
            { 'CursorHold', 'CursorHoldI' },
            { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight }
          )
          vim.api.nvim_create_autocmd(
            { 'CursorMoved', 'CursorMovedI' },
            { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references }
          )
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        -- Auto format on save
        -- if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_formatting, event.buf) then
        --   vim.api.nvim_create_autocmd('BufWritePre', {
        --     callback = function(args)
        --       vim.lsp.buf.format { bufnr = args.buf, id = client.id }
        --     end,
        --   })
        -- end
      end,
    })

    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = true, focusable = false, style = 'minimal' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local dm = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return dm[diagnostic.severity]
        end,
      },
    }

    local cmp = require 'cmp'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- #################################################
    -- V V V V V MODIFIED `servers` TABLE V V V V V
    -- #################################################
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = true,
            },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
      clangd = {},
      pylsp = { -- Add pylsp configuration here
        settings = {
          pylsp = {
            plugins = {
              -- Configure the python executable for pylsp's jedi plugin
              -- This tells pylsp's Jedi to use this specific Python environment
              jedi = { -- pylsp uses 'jedi' as the key for its Jedi plugin settings
                -- environment = '/home/ubuntu/framework/backend/modnn_npu/tt-moreh/tt_moreh_env', -- Path to venv root
                python_path = '/home/ubuntu/framework/backend/modnn_npu/tt-moreh/tt_moreh_env/bin/python3.10', -- Or path to specific python executable
                enabled = true,
              },
              -- You can also configure other pylsp plugins here if needed
              pylint = {
                enabled = true,
                -- If pylint is not in PATH of the python_path above, you might need:
                -- executable = '/home/ubuntu/framework/backend/modnn_npu/tt-moreh/tt_moreh_env/bin/pylint',
              },
              pyflakes = { enabled = true },
              pycodestyle = { enabled = false }, -- Example: disabling a plugin
              -- Add other pylsp plugin configurations as needed
            },
          },
        },
      },
    }
    -- #################################################
    -- ^ ^ ^ ^ ^ MODIFIED `servers` TABLE ^ ^ ^ ^ ^
    -- #################################################

    vim.cmd 'colorscheme onedark_vivid'
    vim.opt.termguicolors = true
    local function apply_transparency()
      local groups = {
        'Normal',
        'NormalFloat',
        'NormalNC',
        'MsgArea',
        'SignColumn',
        'FoldColumn',
        'EndOfBuffer',
        'NonText',
        'ColorColumn',
        'CursorLine',
        'CursorLineNr',
        'StatusLine',
        'StatusLineNC',
        'TabLineFill',
        'WinSeparator',
        'VertSplit',
        'FloatBorder',
      }
      for _, group_name in ipairs(groups) do
        vim.api.nvim_set_hl(0, group_name, { bg = 'NONE', ctermbg = 'NONE' })
      end
    end
    apply_transparency()
    local augroup_transparent = vim.api.nvim_create_augroup('MyTransparentHighlights', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', { group = augroup_transparent, pattern = '*', callback = apply_transparency })

    local ensure_installed_lsp = vim.tbl_keys(servers or {})
    -- Add other tools (linters, formatters) that are not LSPs but you want Mason to install
    local ensure_installed_others = {
      'stylua',
      -- The jedi_language_server entry with specific pythonPath is not needed here
      -- for configuring an already installed pylsp. Mason will install pylsp,
      -- and pylsp itself will be configured via the `servers` table above.
    }
    -- Combine LSP servers and other tools for mason-tool-installer
    local final_ensure_installed = {}
    for _, tool in ipairs(ensure_installed_lsp) do
      table.insert(final_ensure_installed, tool)
    end
    for _, tool in ipairs(ensure_installed_others) do
      table.insert(final_ensure_installed, tool)
    end

    local function filter_diagnostics(diagnostic)
      if diagnostic.source == 'clang' then
        return false
      end
      return true
    end

    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(function(_, result, ctx, config)
      result.diagnostics = vim.tbl_filter(filter_diagnostics, result.diagnostics)
      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end, {})

    require('mason-tool-installer').setup { ensure_installed = final_ensure_installed }

    require('mason-lspconfig').setup {
      automatic_enable = true,
      ensure_installed = {}, -- Let mason-tool-installer handle this.
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server_opts = servers[server_name] or {} -- Get specific settings from our 'servers' table
          -- Ensure capabilities are merged correctly
          server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
          require('lspconfig')[server_name].setup(server_opts)
        end,
      },
    }
  end,
}
