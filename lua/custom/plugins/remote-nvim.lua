return {
  {
    -- Temporarily use the fork that contains the pty=false fix (PR #204)
    'johannes-graner/remote-nvim.nvim',
    branch = 'fix/pty-argument',
    -- version = '*', -- <-- You MUST remove or comment out this line
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      vim.env.DEVPOD_DISABLE_UPDATE_CHECK = 'true'

      -- Suppress LuaLS warnings about missing fields, since the plugin handles defaults internally
      ---@diagnostic disable: missing-fields
      require('remote-nvim').setup {
        progress_view = {
          type = 'popup',
        },
        devpod = {
          -- Using the absolute path guarantees Neovim finds it, regardless of $PATH
          binary = '/usr/local/bin/devpod',
        },
      }
    end,
  },
}
