return {
  -- =====================================================================
  -- 1. CORE TREESITTER & TEXTOBJECTS
  -- =====================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- 👇 MUST be main for Neovim 0.12
    lazy = false, -- 👇 CRITICAL: The new plugin does not support lazy-loading
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main', -- 👇 MUST be main
        init = function()
          vim.g.no_plugin_maps = true
        end,
      },
    },
    config = function()
      -- 1. Install Parsers programmatically
      -- The new nvim-treesitter API natively acts as a no-op for already-installed parsers.
      require('nvim-treesitter').install {
        'bash',
        'c',
        'cpp',
        'python',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }

      -- 2. Natively enable Highlight & Indent per filetype
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
        callback = function(event)
          -- Highlighting
          pcall(vim.treesitter.start, event.buf)
          -- Indentation
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- 3. Incremental selection (Neovim 0.12 natively handles this now!)
      vim.keymap.set({ 'n', 'v' }, '<C-space>', 'v_an', { remap = true, desc = 'Start/expand TS selection' })
      vim.keymap.set('v', '<bs>', 'v_[n', { remap = true, desc = 'Shrink TS selection' })

      -- 4. Initialize textobjects
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = { ['@function.outer'] = 'V', ['@class.outer'] = 'V' },
          include_surrounding_whitespace = false,
        },
      }

      -- 5. Manual Selection Keymaps
      local ts_select = require 'nvim-treesitter-textobjects.select'
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        ts_select.select_textobject('@function.outer', 'textobjects')
      end, { desc = 'Select a whole function' })
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        ts_select.select_textobject('@function.inner', 'textobjects')
      end, { desc = 'Select inner part of a function' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        ts_select.select_textobject('@class.outer', 'textobjects')
      end, { desc = 'Select a whole class' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        ts_select.select_textobject('@class.inner', 'textobjects')
      end, { desc = 'Select inner part of a class' })

      -- 6. Manual Movement Keymaps
      local ts_move = require 'nvim-treesitter-textobjects.move'
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        ts_move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        ts_move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        ts_move.goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        ts_move.goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next class end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        ts_move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        ts_move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        ts_move.goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Previous function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        ts_move.goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Previous class end' })
    end,
  },

  -- =====================================================================
  -- 2. TREESITTER CONTEXT (STICKY HEADER)
  -- =====================================================================
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_lines = 3,
      trim_scope = 'outer',
      mode = 'cursor',
    },
  },

  -- =====================================================================
  -- 3. SMART COMMENTING (MIXED LANGUAGES)
  -- =====================================================================
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    opts = {
      enable_autocmd = false,
    },
    init = function()
      -- Required for lazy loading to work correctly with this plugin
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function(_, opts)
      require('ts_context_commentstring').setup(opts)
      -- Hook it into Neovim 0.10+ native commenting (gc)
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },
}
