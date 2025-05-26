-- File: lua/custom/plugins/fugitive.lua
-- This file defines the lazy.nvim specification for vim-fugitive.

return {
  'tpope/vim-fugitive',
  -- We'll lazy load fugitive when one of its core commands is called.
  -- This improves startup time.
  cmd = {
    'Git',
    'G',       -- Alias for Git
    'Gstatus', -- Common alias often used instead of :Git
    'Gdiffsplit',
    'Gvdiffsplit',
    'Gread',
    'Gwrite',
    'Ggrep',
    'GMove',
    'GRename',
    'GDelete',
    'GRemove',
    'GBlame',
    'GBrowse',
    'Gcommit',
    'Gp', -- Alias for Git push
    'Gpush',
    'Gpull',
    'Gfetch',
    'Glog',
    'Gclog',
    -- Add any other Fugitive commands you frequently use as your first interaction
  },
  -- If you want to set up keymaps or run any configuration code
  -- *after* fugitive is loaded, you can use the config function.
  -- config = function()
  --   -- This is where you can define keymaps or any other setup.
  --   -- For example, let's set up some common keymaps:
  --
  --   local map = vim.keymap.set
  --   local opts = { noremap = true, silent = true }
  --
  --   -- Open Git status window
  --   map('n', '<leader>gs', '<cmd>Gstatus<CR>', { desc = 'Fugitive: Git Status' })
  --   -- For users who prefer :Git
  --   map('n', '<leader>gS', '<cmd>Git<CR>', { desc = 'Fugitive: Git (Main)' })
  --
  --
  --   -- Stage current file
  --   map('n', '<leader>ga', '<cmd>Gwrite<CR>', { desc = 'Fugitive: Git Add (Stage) Current File' })
  --
  --   -- Open blame for the current file
  --   map('n', '<leader>gb', '<cmd>GBlame<CR>', { desc = 'Fugitive: Git Blame' })
  --
  --   -- Open diff for the current file
  --   map('n', '<leader>gd', '<cmd>Gdiffsplit<CR>', { desc = 'Fugitive: Git Diff Current File' })
  --   map('n', '<leader>gvd', '<cmd>Gvdiffsplit<CR>', { desc = 'Fugitive: Git Vertical Diff Current File' })
  --
  --   -- Commit
  --   map('n', '<leader>gc', '<cmd>Git commit<CR>', { desc = 'Fugitive: Git Commit' })
  --
  --   -- Push
  --   map('n', '<leader>gp', '<cmd>Git push<CR>', { desc = 'Fugitive: Git Push' })
  --
  --   -- Pull
  --   map('n', '<leader>gP', '<cmd>Git pull<CR>', { desc = 'Fugitive: Git Pull' }) -- Shift+P for pull
  --
  --   -- Browse the current file on GitHub/GitLab etc. (requires gh.vim or similar for :GBrowse to work fully)
  --   map('n', '<leader>go', '<cmd>GBrowse<CR>', { desc = 'Fugitive: Git Browse (Open on Web)' })
  --
  --   -- Log for current file
  --   map('n', '<leader>gl', '<cmd>0Gclog<CR>', { desc = 'Fugitive: Git Log for Current File' })
  --   -- Full project log
  --   map('n', '<leader>gL', '<cmd>Glog<CR>', { desc = 'Fugitive: Git Log (Project)' })
  --
  --   -- You can also set Vimscript global variables if Fugitive uses them for configuration
  --   -- For example (this is just a hypothetical example, check fugitive's docs for actual options):
  --   -- vim.g.fugitive_no_maps = 1 -- If you wanted to disable fugitive's default maps
  --
  --   -- Indicate that Fugitive's specific config (if any beyond keymaps) is done
  --   -- print("vim-fugitive configured with custom keymaps.")
  -- end,
  -- If you prefer to load it even earlier, you could use:
  -- event = "VeryLazy",
  -- Or, if you want it loaded on startup (not generally recommended for fugitive unless you use it immediately):
  -- lazy = false,
}
