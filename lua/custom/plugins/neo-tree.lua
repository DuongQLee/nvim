return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  config = function()
    -- ## Neo-tree Setup ##
    -- Configuration options must go inside the setup function
    require('neo-tree').setup {
      close_if_last_window = true, -- Close Neovim if Neo-tree is the last window
      -- Add other general Neo-tree options here if needed

      -- Window settings moved here
      window = {
        width = 50, -- Initial width for docked windows (left/right)
        auto_expand_width = true, -- Expand width based on nesting depth
        -- Note: This works best for docked windows (left/right).
        -- It might not have the intended effect for 'float'.
        -- position = "left",    -- Default position
        -- mappings = { ... }    -- Window-specific mappings if needed
      },

      -- Filesystem specific settings (optional, can inherit global window settings)
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = 'open_current',
        -- Example: override window settings just for filesystem
        -- window = {
        --   position = "right",
        --   width = 50,
        --   auto_expand_width = true
        -- }
      },
      -- Add settings for other sources like buffers, git_status if you use them
      -- buffers = { ... },
      -- git_status = { ... },
    }

    -- ## Keymaps ##
    -- Reveal or hide the current file in the filesystem tree (no focus change)
    vim.keymap.set('n', '<C-S-n>', ':Neotree filesystem reveal toggle current<CR>', { desc = 'NeoTree toggle current' })
    -- Reveal or hide the filesystem tree on the right side
    vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal toggle right<CR>', { desc = 'NeoTree toggle right' })
    -- Show buffers in a floating window
    vim.keymap.set('n', '<leader>bf', ':Neotree buffers reveal float<CR>', { desc = 'NeoTree buffers float' })
  end,
}
