-- harpoon.lua

return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    require('harpoon').setup {
      -- Configure the menu appearance
      menu = {
        -- Set the width based on the current window width at setup time.
        -- It takes the full window width (vim.api.nvim_win_get_width(0))
        -- and subtracts 4 columns for padding/aesthetics.
        -- NOTE: This width is calculated ONCE and does NOT automatically
        --       resize if you resize the main Neovim window later.
        width = vim.api.nvim_win_get_width(0) - 4,

        -- You could add other menu settings here if needed, like:
        -- border = "rounded",
      },
      -- Add other global settings here if needed, e.g.:
      -- global_settings = { ... }
    }

    vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, { desc = 'Harpoon: Toggle quick menu' })

    -- Define <C-h> sequences
    -- Use "<C-h>key" syntax for sequences

    -- Ctrl + h, then a : Add current file to Harpoon
    vim.keymap.set('n', '<C-h>a', mark.add_file, { desc = 'Harpoon: Add file' })

    -- Ctrl + h, then d : Remove current file from Harpoon
    vim.keymap.set('n', '<C-h>d', mark.rm_file, { desc = 'Harpoon: Remove file' }) -- Added remove mapping

    -- Ctrl + h, then 1/2/3/4 : Navigate to marked files
    vim.keymap.set('n', '<C-h>1', function()
      ui.nav_file(1)
    end, { desc = 'Harpoon: Navigate to file 1' })
    vim.keymap.set('n', '<C-h>2', function()
      ui.nav_file(2)
    end, { desc = 'Harpoon: Navigate to file 2' })
    vim.keymap.set('n', '<C-h>3', function()
      ui.nav_file(3)
    end, { desc = 'Harpoon: Navigate to file 3' })
    vim.keymap.set('n', '<C-h>4', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon: Navigate to file 4' })

    -- Ctrl + h, then j : Navigate to next marked file
    vim.keymap.set('n', '<C-h>j', function()
      ui.nav_next()
    end, { desc = 'Harpoon: Navigate Next' })

    -- Ctrl + h, then p (or k) : Navigate to previous marked file
    vim.keymap.set('n', '<C-h>h', function()
      ui.nav_prev()
    end, { desc = 'Harpoon: Navigate Prev' })
    -- Alternative using k for previous, more Vim-like with j/k navigation
    -- vim.keymap.set('n', '<C-h>k', function() ui.nav_prev() end, { desc = 'Harpoon: Navigate Prev' })
  end,
}
