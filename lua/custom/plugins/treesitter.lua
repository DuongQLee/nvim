return {
  -- =====================================================================
  -- 1. CORE TREESITTER & TEXTOBJECTS
  -- =====================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        init = function()
          vim.g.no_plugin_maps = true
        end,
      },
    },
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>', -- Start selection
          node_incremental = '<C-space>', -- Expand to next outer node
          scope_incremental = false, -- (Rarely used) Expand to next scope
          node_decremental = '<bs>', -- Shrink selection
        },
      },
      ensure_installed = { 'bash', 'c', 'cpp', 'python', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- Initialize textobjects
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = { ['@function.outer'] = 'V', ['@class.outer'] = 'V' },
          -- 👇 CHANGED: Prevents swallowing adjacent blank lines during visual selection
          include_surrounding_whitespace = false,
        },
        -- ITEM 3: JUMPING BETWEEN FUNCTIONS
        move = {
          enable = true,
          set_jumps = true, -- Adds jumps to the jumplist so you can use Ctrl-o to go back
          goto_next_start = {
            [']m'] = { query = '@function.outer', desc = 'Next function start' },
            [']]'] = { query = '@class.outer', desc = 'Next class start' },
          },
          goto_next_end = {
            [']M'] = { query = '@function.outer', desc = 'Next function end' },
            [']['] = { query = '@class.outer', desc = 'Next class end' },
          },
          goto_previous_start = {
            ['[m'] = { query = '@function.outer', desc = 'Previous function start' },
            ['[['] = { query = '@class.outer', desc = 'Previous class start' },
          },
          goto_previous_end = {
            ['[M'] = { query = '@function.outer', desc = 'Previous function end' },
            ['[]'] = { query = '@class.outer', desc = 'Previous class end' },
          },
        },
      }

      -- Manual keymaps for selection (vaf, vif, etc.)
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
    end,
  },

  -- =====================================================================
  -- 2. TREESITTER CONTEXT (STICKY HEADER)
  -- =====================================================================
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      max_lines = 3, -- Limits the sticky header to 3 lines so it doesn't hog the screen
      trim_scope = 'outer',
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
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
    opts = {}, -- This enables it
  },
}
