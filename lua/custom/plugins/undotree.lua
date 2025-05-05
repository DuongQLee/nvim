return {
  {
    'mbbill/undotree',
    keys = {
      -- Add a keymap to toggle Undotree
      -- Example: Leader + u
      { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Toggle Undotree' },
    },
    config = function()
      -- Optional configuration for undotree
      -- Example: Focus the undotree window when opened
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
}
