vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- ==========================================
-- Options
-- ==========================================
vim.opt.swapfile = false
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false -- Disables folding by default when you open a file
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.o.ttimeoutlen = 30
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
-- Invisible Character
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '█' }
vim.api.nvim_set_hl(0, 'NonText', { fg = '#E06C75', bold = true })
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 15
vim.opt.confirm = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- ==========================================
-- Keymaps
-- ==========================================
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Move highlighted lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Append line below to current line, keeping cursor in place
vim.keymap.set('n', 'J', 'mzJ`z')
-- Half page jumps, keeping cursor centered
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- Search next/prev, keeping cursor centered
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '=ap', "ma=ap'a")
vim.keymap.set('n', '<leader>zig', '<cmd>LspRestart<cr>')

-- Paste over selection without replacing your current yank buffer
vim.keymap.set('x', '<C-p>', [["_dP]])

-- Yank directly to system clipboard
vim.keymap.set({ 'n', 'v' }, '<C-y>', [["+y]])
vim.keymap.set('n', '<C-Y>', [["+Y]])

-- Delete into void register (doesn't overwrite yank buffer)
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')
vim.keymap.set('n', '<leader>c', '<cmd>cclose<CR>')

-- Search and replace the exact word currently under the cursor globally
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Make the current file executable
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- Source current file
vim.keymap.set('n', '<leader><leader>', function()
  vim.cmd 'so'
end)

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<CR>', 'o<Esc>', { noremap = true, silent = true, desc = 'Add blank line above current line' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ==========================================
-- Custom Toggles (Diagnostics & Virtual Text)
-- ==========================================
_G.diagnostics_are_shown = true
function _G.ToggleDiagnosticsVisibility()
  if _G.diagnostics_are_shown then
    vim.diagnostic.hide()
    _G.diagnostics_are_shown = false
    print 'Diagnostics hidden'
  else
    vim.diagnostic.show()
    _G.diagnostics_are_shown = true
    print 'Diagnostics shown'
  end
end
vim.keymap.set('n', '<leader>td', _G.ToggleDiagnosticsVisibility, { desc = 'Toggle Diagnostics Visibility (Hide/Show)' })

function _G.ToggleVirtualText()
  local current_vt_config = vim.diagnostic.config().virtual_text
  local is_currently_enabled = current_vt_config and (current_vt_config == true or type(current_vt_config) == 'table')
  local new_state = not is_currently_enabled

  vim.diagnostic.config { virtual_text = new_state }
  print('Virtual text diagnostics: ' .. (new_state and 'Shown' or 'Hidden'))
end
vim.keymap.set('n', '<leader>tv', _G.ToggleVirtualText, { desc = 'Toggle Virtual Text Diagnostics' })

-- ==========================================
-- Autocommands
-- ==========================================
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Prevent auto-commenting on new lines
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'

-- ==========================================
-- Lazy.nvim Bootstrapping
-- ==========================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- Plugins
-- ==========================================
require('lazy').setup({
  {
    'olimorris/onedarkpro.nvim',
    priority = 1000,
    opts = {
      transparent = true,
      styles = { sidebars = 'transparent', floats = 'transparent' },
    },
  },

  {
    'benlubas/molten-nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    build = ':UpdateRemotePlugins',
    init = function()
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_output = false
      vim.g.molten_output_win_max_height = 15
      -- Requires Kitty terminal IN WSL or Windows Terminal Preview
      vim.g.molten_image_provider = 'kitty'
    end,
    config = function()
      local map = vim.keymap.set
      map('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Initialize the plugin' })
      map('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'run operator selection' })
      map('n', '<localleader>rl', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'evaluate line' })
      map('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { silent = true, desc = 're-evaluate cell' })
      map('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { silent = true, desc = 'evaluate visual selection' })
      map('n', '<localleader>rd', ':MoltenDelete<CR>', { silent = true, desc = 'molten delete cell' })
      map('n', '<localleader>oh', ':MoltenHideOutput<CR>', { silent = true, desc = 'hide output' })
      map('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'show/enter output' })
    end,
  },

  {
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

  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup { styles = { comments = { italic = false } } }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Loads your modularized plugins from `lua/custom/plugins/`
  { import = 'custom.plugins' },
}, {
  ui = {
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

-- vim: ts=2 sts=2 sw=2 et

-- ==========================================
-- 🛡️ Invisible Character Sanitizer
-- ==========================================
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto-replace invisible/non-breaking spaces with normal spaces',
  group = vim.api.nvim_create_augroup('SanitizeInvisibleChars', { clear = true }),
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    -- Replace non-breaking spaces (U+00A0) with standard spaces
    vim.cmd [[:keepjumps keeppatterns %s/\%u00a0/ /ge]]
    -- Delete zero-width spaces (U+200B) entirely
    vim.cmd [[:keepjumps keeppatterns %s/\%u200b//ge]]
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Makes the background of the sticky header slightly different
vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#1e1e2e' }) -- Change hex to match your theme!

-- Adds a distinct underline to the bottom of the sticky header
vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = 'Grey' })

-- Matches the line numbers in the context to the same background
vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#1e1e2e', fg = '#888888' })
