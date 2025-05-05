-- lua/plugins/alpha.lua (or add to your main plugins file)

return {
  'goolord/alpha-nvim',
  event = 'VimEnter', -- Load it when Neovim starts and enters VimEnter event
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: for icons
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard' -- Or require('alpha.themes.startify')

    -- Set up header (ASCII art)
    dashboard.section.header.val = {
      [[                                                         ]],
      [[              ███╗   ██╗ ███████╗██╗   ██╗██╗ ██████╗     ]],
      [[              ████╗  ██║ ██╔════╝██║   ██║██║██╔════╝     ]],
      [[              ██╔██╗ ██║ ███████╗██║   ██║██║██║  ███╗    ]],
      [[              ██║╚██╗██║ ╚════██║██║   ██║██║██║   ██║    ]],
      [[              ██║ ╚████║ ███████║╚██████╔╝██║╚██████╔╝    ]],
      [[              ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝ ╚═╝ ╚═════╝     ]],
      [[                                                         ]],
    }
    dashboard.section.header.opts.hl = 'Include' -- Highlight group for the header

    -- Set up buttons/menu
    dashboard.section.buttons.val = {
      dashboard.button('f', '󰈞  Find file', ':Telescope find_files <CR>'), -- Requires Telescope
      dashboard.button('n', '  New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('r', '  Recent files', ':Telescope oldfiles <CR>'), -- Requires Telescope
      dashboard.button('g', '󰈬  Find text', ':Telescope live_grep <CR>'), -- Requires Telescope
      dashboard.button('s', '  Restore session', [[:lua require('persistence').load() <CR>]]), -- Requires persistence.nvim
      dashboard.button('l', '󰒲  Lazy', ':Lazy<CR>'),
      dashboard.button('q', '  Quit', ':qa<CR>'),
    }

    -- Set up footer
    -- dashboard.section.footer.val = "Your custom footer text"
    -- dashboard.section.footer.opts.hl = 'Type'

    -- Send config to Alpha
    alpha.setup(dashboard.opts)

    -- Optional: Disable buffer modification warning for Alpha buffer
    vim.cmd [[
      autocmd FileType alpha setlocal nomodified
    ]]
  end,
}
