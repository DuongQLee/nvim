return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      -- This handles the inline ghost text
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          -- Changed to <C-l> (Ctrl+L) to avoid terminal freezing issues with <C-q>
          accept = '<C-l>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = {
        enabled = false, -- Disable the panel if you only want inline suggestions
      },
    }
  end,
}
