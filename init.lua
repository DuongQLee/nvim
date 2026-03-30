-- ==============================================================================
-- 1. GLOBALS
-- ==============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- ==============================================================================
-- 2. CORE OPTIONS
-- ==============================================================================
-- UI & Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.showmode = false
vim.opt.cursorline = true
vim.opt.scrolloff = 15
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '█' }
vim.api.nvim_set_hl(0, 'NonText', { fg = '#E06C75', bold = true })

-- Search & Behavior
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'
vim.opt.mouse = 'a'
vim.opt.confirm = true
vim.opt.undofile = true
vim.opt.swapfile = false

-- Timing
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.o.ttimeoutlen = 30

-- Indentation & Folding
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldenable = false -- Disables folding by default when opening a file

-- Clipboard (Scheduled for faster startup)
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- ==============================================================================
-- 3. CUSTOM UTILITY FUNCTIONS
-- ==============================================================================
local diagnostics_active = true
local function toggle_diagnostics()
  if diagnostics_active then
    vim.diagnostic.hide()
    print 'Diagnostics hidden'
  else
    vim.diagnostic.show()
    print 'Diagnostics shown'
  end
  diagnostics_active = not diagnostics_active
end

local function toggle_virtual_text()
  local current_vt_config = vim.diagnostic.config().virtual_text
  local is_currently_enabled = current_vt_config and (current_vt_config == true or type(current_vt_config) == 'table')
  local new_state = not is_currently_enabled

  vim.diagnostic.config { virtual_text = new_state }
  print('Virtual text diagnostics: ' .. (new_state and 'Shown' or 'Hidden'))
end

-- ==============================================================================
-- 4. KEYMAPS
-- ==============================================================================
local map = vim.keymap.set

-- General utilities
map('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open Netrw' })
map('n', '<leader><leader>', function()
  vim.cmd 'so'
end, { desc = 'Source current file' })
map('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'Make current file executable' })
map('n', '<leader>zig', '<cmd>LspRestart<cr>', { desc = 'Restart LSP' })
map('n', 'Q', '<nop>', { desc = 'Disable Ex mode' })

-- Quick toggles
map('n', '<leader>td', toggle_diagnostics, { desc = 'Toggle Diagnostics Visibility' })
map('n', '<leader>tv', toggle_virtual_text, { desc = 'Toggle Virtual Text' })

-- Window & Buffer Navigation
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
map('n', '<C-k>', '<cmd>cnext<CR>zz', { desc = 'Next quickfix item' })
map('n', '<C-j>', '<cmd>cprev<CR>zz', { desc = 'Previous quickfix item' })
map('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = 'Next loclist item' })
map('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = 'Previous loclist item' })
map('n', '<leader>c', '<cmd>cclose<CR>', { desc = 'Close quickfix list' })
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

-- Editing & Movement
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('n', 'J', 'mzJ`z', { desc = 'Append line below, keep cursor position' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Page down, keep cursor centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Page up, keep cursor centered' })
map('n', 'n', 'nzzzv', { desc = 'Next search result, keep cursor centered' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search result, keep cursor centered' })
map('n', '=ap', "ma=ap'a", { desc = 'Format paragraph and restore cursor' })
map('n', '<CR>', 'o<Esc>', { noremap = true, silent = true, desc = 'Add blank line below' })

-- Yank & Paste overrides
map('x', '<C-p>', [["_dP]], { desc = 'Paste over selection without replacing yank buffer' })
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete to void register' })
map({ 'n', 'v' }, '<C-y>', [["+y]], { desc = 'Yank to system clipboard' })
map('n', '<C-Y>', [["+Y]], { desc = 'Yank line to system clipboard' })

-- Global Search & Replace
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Search and replace word under cursor' })

-- ==============================================================================
-- 5. AUTOCOMMANDS
-- ==============================================================================
-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Prevent auto-commenting on new lines
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Disable auto-commenting on new line',
  pattern = '*',
  command = 'set formatoptions-=cro | setlocal formatoptions-=cro',
})

-- Invisible Character Sanitizer
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Auto-replace invisible/non-breaking spaces with normal spaces',
  group = vim.api.nvim_create_augroup('SanitizeInvisibleChars', { clear = true }),
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos '.'
    vim.cmd [[:keepjumps keeppatterns %s/\%u00a0/ /ge]] -- U+00A0 to space
    vim.cmd [[:keepjumps keeppatterns %s/\%u200b//ge]] -- Delete U+200B
    vim.fn.setpos('.', save_cursor)
  end,
})

-- Dynamic UI Highlight Overrides (Ensures colorscheme doesn't overwrite them)
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Apply custom highlight overrides after colorscheme loads',
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#1e1e2e' })
    vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline = true, sp = 'Grey' })
    vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = '#1e1e2e', fg = '#888888' })
  end,
})

-- ==============================================================================
-- 6. PLUGIN MANAGER (LAZY.NVIM)
-- ==============================================================================
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ==============================================================================
-- 7. PLUGINS CONFIGURATION
-- ==============================================================================
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
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup { styles = { comments = { italic = false } } }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
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
      vim.g.molten_image_provider = 'kitty'
    end,
    config = function()
      local m = vim.keymap.set
      m('n', '<localleader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Molten: Init' })
      m('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'Molten: Evaluate operator' })
      m('n', '<localleader>rl', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'Molten: Evaluate line' })
      m('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { silent = true, desc = 'Molten: Re-evaluate cell' })
      m('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { silent = true, desc = 'Molten: Evaluate visual' })
      m('n', '<localleader>rd', ':MoltenDelete<CR>', { silent = true, desc = 'Molten: Delete cell' })
      m('n', '<localleader>oh', ':MoltenHideOutput<CR>', { silent = true, desc = 'Molten: Hide output' })
      m('n', '<localleader>os', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'Molten: Show output' })
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
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

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

  -- Modularized plugins
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
