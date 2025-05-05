-- Inside your lazy.nvim setup, add this entry:

return { -- Or add to your existing plugins table

  -- Essential Git integration plugin
  'tpope/vim-fugitive',

  -- Optional: Configuration for lazy loading
  -- Load fugitive when you run any of its core commands
  cmd = {
    'Git',
    'G', -- The shorter alias for :Git
    'Gstatus',
    'Gdiffsplit',
    'Gblame',
    'Gcommit',
    'Gpush',
    'Gpull',
    'Glog',
    'GMove',
    'GRename',
    'GDelete',
    'GBrowse',
    -- Add any other fugitive commands you use often
  },

  -- Optional: Define keymaps which will also trigger loading
  -- keys = {
  --   { "<leader>gs", "<cmd>Gstatus<CR>", desc = "Git Status" },
  --   { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git Diff" },
  --   { "<leader>gc", "<cmd>Gcommit<CR>", desc = "Git Commit" },
  --   { "<leader>gb", "<cmd>Gblame<CR>", desc = "Git Blame" },
  --   { "<leader>gl", "<cmd>Glog<CR>", desc = "Git Log" },
  --   { "<leader>gp", "<cmd>Gpush<CR>", desc = "Git Push" },
  --   -- Add more maps as needed
  -- },

  -- Optional: Configuration function (runs after plugin loads)
  -- config = function()
  --  -- You could define additional mappings here if you prefer
  --  -- vim.keymap.set('n', '<leader>gw', '<cmd>Gwrite<CR>', { desc = "Git Write (add/stage)" })
  -- end,
} -- End of the fugitive spec
