return { -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  version = 'v0.1.8', -- Pins the plugin to the last stable version (Fixes Nvim 0.11 crashes)
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
    -- Mason setup
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- Fidget status updates
    { 'j-hui/fidget.nvim', opts = {} },
    -- Completion Engine setup
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
      },
    },
  },
  config = function()
    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
      },
      default_format_opts = { lsp_format = 'fallback' },
      format_on_save = { lsp_format = 'fallback', timeout_ms = 3000 },
    }

    -- ==============================================================================
    -- 🧠 LSP Keymaps & Autocommands
    -- ==============================================================================
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          local effective_mode = mode or 'n'
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

        -- Format keymap
        if client and client:supports_method('textdocument/formatting', { bufnr = event.buf }) then
          vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end, { desc = 'format document (conform/lsp)', noremap = true, silent = true, buffer = event.buf })
        end

        -- Document Highlight autocommands
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

        -- Inlay hints
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- ==============================================================================
    -- 🎨 Diagnostic UI Configuration
    -- ==============================================================================
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
          return diagnostic.message
        end,
      },
    }

    -- ==============================================================================
    -- 🐍 Dynamic Python Environment Resolvers (Optimized for `uv` on macOS)
    -- ==============================================================================
    local function get_python_path()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      -- Fallback to local `.venv` typically created by `uv`
      local local_venv = vim.fn.getcwd() .. '/.venv/bin/python'
      if vim.fn.filereadable(local_venv) == 1 then
        return local_venv
      end
      -- Default macOS Python path fallback
      return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
    end

    local function get_pylint_path()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/pylint'
      end
      -- Prioritize local project pylint to solve import errors
      local local_pylint = vim.fn.getcwd() .. '/.venv/bin/pylint'
      if vim.fn.filereadable(local_pylint) == 1 then
        return local_pylint
      end
      -- Fallback to global/Mason pylint
      return vim.fn.exepath 'pylint' or 'pylint'
    end

    -- ==============================================================================
    -- 📡 LSP Servers Configuration
    -- ==============================================================================
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            format = { enable = true },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
      clangd = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              jedi = {
                environment = get_python_path(),
                enabled = true,
              },
              pylint = {
                enabled = true,
                executable = get_pylint_path(),
              },
              pyflakes = { enabled = true },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              pyls_isort = { enabled = false },
            },
          },
        },
      },
    }

    -- ==============================================================================
    -- 💅 UI Tweaks (Colorscheme & Transparency)
    -- ==============================================================================
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

    -- ==============================================================================
    -- 🏗️ Mason Installer Integration
    -- ==============================================================================
    local ensure_installed_lsp = vim.tbl_keys(servers or {})

    -- AUTO-INSTALL FORMATTERS AND LINTERS HERE
    local ensure_installed_others = {
      'stylua',
      'black',
      'isort',
      'clang-format',
      'pylint',
    }

    local final_ensure_installed = {}
    for _, tool in ipairs(ensure_installed_lsp) do
      table.insert(final_ensure_installed, tool)
    end
    for _, tool in ipairs(ensure_installed_others) do
      table.insert(final_ensure_installed, tool)
    end

    -- Clang diagnostic filter
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

    -- Setup Mason Tools
    require('mason-tool-installer').setup { ensure_installed = final_ensure_installed }

    -- Setup Mason LSP Config
    require('mason-lspconfig').setup {
      automatic_enable = true,
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server_opts = servers[server_name] or {}
          server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})
          require('lspconfig')[server_name].setup(server_opts)
        end,
      },
    }
  end,
}
