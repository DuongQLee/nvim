-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
--
--

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Basic clipboard interaction
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste clipboard content' })
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<CR>', 'o<Esc>', {
  noremap = true,
  silent = true,
  desc = 'Add blank line above current line',
})

-- Simple toggle using a global state variable (assumes shown initially)
_G.diagnostics_are_shown = true

function _G.ToggleDiagnosticsVisibility()
  if _G.diagnostics_are_shown then
    vim.diagnostic.hide() -- Hide diagnostics globally
    _G.diagnostics_are_shown = false
    print 'Diagnostics hidden'
  else
    vim.diagnostic.show() -- Show diagnostics globally
    _G.diagnostics_are_shown = true
    print 'Diagnostics shown'
  end
end

-- Map a key to toggle visibility (e.g., <leader>td)
-- Use 'n' for normal mode, you could add 'i' for insert mode etc. if needed
vim.keymap.set('n', '<leader>td', _G.ToggleDiagnosticsVisibility, { desc = 'Toggle Diagnostics Visibility (Hide/Show)' })
-- Toggle Virtual Text only
function _G.ToggleVirtualText()
  -- Get current virtual_text setting (might be boolean or table)
  local current_vt_config = vim.diagnostic.config().virtual_text
  -- Determine the current state (simple check if it's truthy)
  local is_currently_enabled = current_vt_config and (current_vt_config == true or type(current_vt_config) == 'table')

  -- Toggle the state
  local new_state = not is_currently_enabled
  vim.diagnostic.config { virtual_text = new_state }
  print('Virtual text diagnostics: ' .. (new_state and 'Shown' or 'Hidden'))
end

-- Map a key to toggle virtual text (e.g., <leader>tv)
vim.keymap.set('n', '<leader>tv', _G.ToggleVirtualText, { desc = 'Toggle Virtual Text Diagnostics' })

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
-- In your init.lua or a relevant config file
vim.opt.foldmethod = 'indent' -- Or 'treesitter'
vim.opt.foldlevelstart = 99 -- Optional: Start with folds open
vim.opt.foldenable = true -- Ensure folding is enabled
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.ttimeoutlen = 30
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 15
vim.opt.confirm = true
-- Set tab size and indentation settings
vim.opt.tabstop = 2 -- How many spaces a <Tab> character is worth visually
vim.opt.shiftwidth = 2 -- How many spaces to use for each step of (auto)indent
vim.opt.softtabstop = 2 -- Number of spaces to insert/delete when <Tab>/<BS> is used
vim.opt.expandtab = true -- Use spaces instead of literal <Tab> characters

-- Optional, but recommended for consistency:
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
-- vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
-- vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
-- vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.

  {
    'olimorris/onedarkpro.nvim',
    priority = 1000, -- Ensure it loads first
    opts = {
      -- Add theme options here if needed, check the plugin's README
      transparent = true, -- *** Add this line to enable transparency ***
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
      -- Optional: Configure styles like italics if desired
      -- styles = {
      --     comments = { italic = true },
      --     keywords = { italic = true },
      --     -- Add/customize styles as needed
      -- }
    },
  },
  {
    'benlubas/molten-nvim',
    version = '*', -- Pin to a specific version tag if needed, e.g. "^1.0.0"
    dependencies = { 'nvim-lua/plenary.nvim' }, -- Optional but often useful
    -- This command is crucial for plugins with Python/remote components
    build = ':UpdateRemotePlugins',
    init = function()
      -- Basic configuration options - apply BEFORE plugin loads
      -- Set these according to your preference
      vim.g.molten_virt_text_output = true -- Show output as virtual text
      vim.g.molten_virt_lines_output = false -- Don't show output on virtual lines
      vim.g.molten_output_win_max_height = 15 -- Limit output window height

      -- === Image Provider Configuration (Optional - for Plots) ===
      -- Choose ONE. Requires installing tools IN WSL & terminal support
      -- vim.g.molten_image_provider = "ueberzug" -- Requires ueberzugpp (pip install ueberzugpp)
      vim.g.molten_image_provider = 'kitty' -- If using Kitty terminal IN WSL or Windows Terminal Preview
      -- vim.g.molten_image_provider = "chafa" -- Requires chafa (sudo apt install chafa)
      -- vim.g.molten_image_provider = "jp_proxy" -- Tries to use browser via Jupyter comms
      -- vim.g.molten_image_provider = nil -- Default: No image support
    end,
    config = function()
      -- Optional: Setup keymaps here or in your general keymap file
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- Initialize Kernel
      map('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Initialize the plugin' })
      map('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'run operator selection' })
      map('n', '<localleader>rl', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'evaluate line' })
      map('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { silent = true, desc = 're-evaluate cell' })
      map('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { silent = true, desc = 'evaluate visual selection' })
      vim.keymap.set('n', '<localleader>rd', ':MoltenDelete<CR>', { silent = true, desc = 'molten delete cell' })
      vim.keymap.set('n', '<localleader>oh', ':MoltenHideOutput<CR>', { silent = true, desc = 'hide output' })
      vim.keymap.set('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'show/enter output' })
    end,
  },
  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.
  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin
  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- lua/plugins/lspconfig.lua (or similar lazy.nvim spec file)

  { -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
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
        },
      },
    },
    config = function()
      -- LspAttach autocommand (Existing)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- V V V V V MODIFIED map function V V V V V --
          -- Handles mode correctly and checks desc type
          local map = function(keys, func, desc, mode)
            local effective_mode = mode or 'n' -- Default to 'n' if mode is nil
            if type(desc) == 'string' then
              vim.keymap.set(effective_mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            else
              -- Fallback if desc is not a string
              vim.keymap.set(effective_mode, keys, func, { buffer = event.buf, desc = 'LSP: Action (Desc Error)' })
              print("Warning: Invalid 'desc' type passed to map for keys:", keys)
            end
          end
          -- ^ ^ ^ ^ ^ MODIFIED map function ^ ^ ^ ^ ^ --

          -- Existing keymaps (kept as is)
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' }) -- Mode passed correctly here
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- Get client instance
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- ############################################## --
          -- V V V V Corrected Formatting Keymap Call V V V --
          -- ############################################## --
          -- Check if the attached client supports formatting
          -- Use client:supports_method() syntax (colon) to address deprecation warning
          if client and client:supports_method('textDocument/formatting', { bufnr = event.buf }) then
            -- Correct argument order: map(KEYS, FUNCTION, DESCRIPTION_STRING, MODE_TABLE)
            map('<leader>f', function()
              vim.lsp.buf.format { async = true, timeout_ms = 2000 }
            end, 'Format Document', { 'n', 'v' })
            print('Formatting keymap (<leader>f) set for buffer:', event.buf)
          else
            print('Client does not support formatting for buffer:', event.buf)
          end
          -- ############################################## --
          -- ^ ^ ^ ^ Corrected Formatting Keymap Call ^ ^ ^ --
          -- ############################################## --

          -- V V V V V MODIFIED client_supports_method helper V V V V V --
          -- Uses colon syntax where appropriate
          local function client_supports_method(client_instance, method, bufnr)
            if not client_instance then
              return false
            end -- Add nil check for safety
            if vim.fn.has 'nvim-0.11' == 1 then
              -- Modern Neovim uses colon syntax and takes bufnr in opts table
              return client_instance:supports_method(method, { bufnr = bufnr })
            else
              -- Older Neovim used dot syntax and opts table
              -- Check if the method exists before calling
              return client_instance.supports_method and client_instance.supports_method(method, { bufnr = bufnr })
            end
          end
          -- ^ ^ ^ ^ ^ MODIFIED client_supports_method helper ^ ^ ^ ^ ^ --

          -- Existing document highlight logic (now uses updated helper)
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

          -- Existing inlay hints toggle (now uses updated helper)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config (Existing, kept as is)
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
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

      -- Setup nvim-cmp capabilities (Existing, kept as is)
      local cmp = require 'cmp'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Servers table definition (Existing, kept as is)
      local servers = {
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
        clangd = {}, -- Correctly includes clangd
      }

      -- Transparency settings (Existing, kept as is)
      -- Consider moving this to your colorscheme setup file if possible
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

      -- Setup mason-tool-installer (Existing, kept as is)
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        jedi_language_server = { python = { pythonPath = '/home/ubuntu/framework/backend/modnn_npu/tt-moreh/tt_moreh_env/bin/python3.10' } },
        'clangd',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Setup mason-lspconfig handlers (Existing, kept as is)
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- Handled by mason-tool-installer
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- Auto-Format on Save for C/C++ (Existing, kept as is)
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
        pattern = { '*.c', '*.cpp', '*.h', '*.hpp', '*.cc', '*.hh', '*.objc', '*.objcpp', '*.cuda' },
        callback = function(args)
          local clients = vim.lsp.get_active_clients { bufnr = args.buf, name = 'clangd' }
          if #clients > 0 then
            print('Attempting format on save for buffer:', args.buf)
            vim.lsp.buf.format { bufnr = args.buf, async = true, timeout_ms = 2000 }
          else
            print('Clangd not active for buffer, skipping format on save:', args.buf)
          end
        end,
        desc = 'Format C/C++/ObjC/CUDA files using LSP before saving',
      })
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = 'n',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
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
        -- Conform can also run multiple formatters sequentially
        python = { 'isort', 'black' },
        cpp = { 'clangd' },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
