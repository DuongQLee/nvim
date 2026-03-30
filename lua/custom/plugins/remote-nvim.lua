return {
  {
    'amitds1997/remote-nvim.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('remote-nvim').setup {
        progress_view = {
          type = 'popup',
        },
        -- Force the devpod check to fail safely and skip to Docker
        devpod = {
          binary = 'false',
        },
      }
    end,
  },
}
