return { -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
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
            vim.keymap.set(effective_mode, keys, func, { buffer = event.buf, desc = 'LSP: Action' })
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
        if not client then
          return
        end

        -- Document Highlight autocommands (Modern 0.11 supports_method call)
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, { bufnr = event.buf }) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints (Modern 0.11 toggle API)
        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, { bufnr = event.buf }) then
          map('<leader>th', function()
            local is_enabled = vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
            vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = event.buf })
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
    -- 🐍 Dynamic Python Environment Resolvers
    -- ==============================================================================
    local function get_python_path()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
      end
      local local_venv = vim.fn.getcwd() .. '/.venv/bin/python'
      if vim.fn.filereadable(local_venv) == 1 then
        return local_venv
      end
      return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
    end

    local function get_pylint_path()
      if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/pylint'
      end
      local local_pylint = vim.fn.getcwd() .. '/.venv/bin/pylint'
      if vim.fn.filereadable(local_pylint) == 1 then
        return local_pylint
      end
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
      html = {},
      pyright = {},
      ruff = {},
      bashls = {},
      dockerls = {},
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
    local ensure_installed_others = {
      'stylua',
      'clang-format',
      'jq',
      'shfmt',
      'shellcheck',
      'hadolint',
    }

    -- 0.11 Modern replacement for table merging
    local final_ensure_installed = vim.iter({ vim.tbl_keys(servers), ensure_installed_others }):flatten():totable()

    -- 0.11 Modern diagnostic filtering
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(function(_, result, ctx, config)
      if result and result.diagnostics then
        result.diagnostics = vim
          .iter(result.diagnostics)
          :filter(function(diagnostic)
            return diagnostic.source ~= 'clang'
          end)
          :totable()
      end
      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end, {})

    require('mason-tool-installer').setup { ensure_installed = final_ensure_installed }

    require('mason-lspconfig').setup {
      automatic_enable = true,
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server_opts = servers[server_name] or {}
          server_opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_opts.capabilities or {})

          -- CRITICAL FIX: Neovim 0.11 deprecation bypass
          if vim.fn.has 'nvim-0.11' == 1 then
            require 'lspconfig' -- Ensure lspconfig data is loaded into Neovim
            local default_config = vim.lsp.config[server_name] or {}
            -- Combine our custom settings with the defaults
            vim.lsp.config[server_name] = vim.tbl_deep_extend('force', default_config, server_opts)
            -- Use the new 0.11 native enable function instead of the old setup()
            vim.lsp.enable(server_name)
          else
            -- Fallback for older Neovim versions
            require('lspconfig')[server_name].setup(server_opts)
          end
        end,
      },
    }
  end,
}
