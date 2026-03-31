-- oil.lua
-- Configuration file for the oil.nvim plugin

return {
  -- The plugin repository on GitHub
  'stevearc/oil.nvim',

  -- Specify any dependencies. nvim-web-devicons is common for file icons.
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  -- Configuration function that runs after the plugin is loaded
  config = function()
    -- Require the oil module and call its setup function
    require('oil').setup {
      -- You can add your desired configuration options here.
      -- These are just a few examples, refer to the oil.nvim documentation
      -- for a full list of options.

      -- Set the default view to be a floating window
      default_file_explorer = false, -- Set to true to replace netrw
      columns = {
        'icon', -- Show file icons
        -- 'permissions',               -- Show file permissions
        -- 'size',                      -- Show file size
        -- 'mtime',                     -- Show last modified time
      },
      keymaps = {
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
      },
    }

    -- Set up a global keymap in normal mode to open Oil
    -- This maps your leader key followed by '-' to open Oil in the current window
    vim.keymap.set('n', '<leader>-', '<CMD>Oil<CR>', { desc = 'Open Oil' })

    -- You might also want a keymap to open Oil in the parent directory
    -- vim.keymap.set('n', '<leader>o', '<CMD>Oil --float<CR>', { desc = 'Open Oil (Float)' })
  end,
}
