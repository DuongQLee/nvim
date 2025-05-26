-- In your plugins configuration (e.g., lua/plugins/copilot.lua)
return {
  'github/copilot.vim',
  -- Optionally configure keymaps or settings here or later
  --   -- Example: Disable default Tab mapping and set custom accept key
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.keymap.set('i', '<C-q>', 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, silent = true })
  end,
}
