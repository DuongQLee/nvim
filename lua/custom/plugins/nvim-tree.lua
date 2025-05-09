-- File: lua/plugins/nvim-tree.lua
-- Configuration for nvim-tree.lua

return {
  'nvim-tree/nvim-tree.lua',
  version = '*', -- Or pin to a specific Git tag/branch for stability, e.g., "v1.2.3"
  lazy = false, -- Load nvim-tree on startup. Set to true if you prefer to load it on command/event.
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- Optional, but recommended for file icons
  },
  config = function()
    local nvimtree = require 'nvim-tree'

    -- Optional: If you have nvim-web-devicons and want to ensure it's set up
    -- (though nvim-tree often handles this if it's a dependency)
    local devicons_status_ok, devicons = pcall(require, 'nvim-web-devicons')
    if devicons_status_ok then
      devicons.setup {
        -- Your nvim-web-devicons specific settings (if any)
        -- For example, override default icons:
        -- override = {
        --   cs = {
        --     icon = "󰌛",
        --     color = "#596706",
        --     name = "Cs"
        --   }
        -- }
      }
    end

    nvimtree.setup {
      -- When true, this module will prevent netrw from loading to prevent conflicts
      disable_netrw = true,
      -- When true, this module will hijack netrw buffers. Enabling this is mostly effectively
      -- the same as `disable_netrw` but can prevent some subtle effects.
      hijack_netrw = true,

      -- Update the focused file on BufEnter, if the current buffer is in nvim-tree.
      update_focused_file = {
        enable = true,
        -- Update the root directory of nvim-tree to the CWD of the buffer.
        update_cwd = true,
      },

      -- Keybindings for actions in the NvimTree window
      view = {
        adaptive_size = true, -- Adjusts NvimTree window size to content
        width = 50, -- Default width of the NvimTree window
        side = 'right', -- Can be 'left' or 'right'
        -- Preserve the cursor position when switching buffers
        preserve_window_proportions = true,
        -- Hide numbers, relative numbers, and signcolumn for a cleaner look
        number = false,
        relativenumber = false,
        signcolumn = 'no', -- Or "yes" if you want to see diagnostic/git markers here
      },

      -- Options for rendering the NvimTree
      renderer = {
        group_empty = true, -- Show empty folders
        highlight_git = true, -- Highlight files based on Git status
        highlight_opened_files = 'none', -- Options: "none", "icon", "name", "all"
        indent_markers = {
          enable = true, -- Show indentation markers
          -- icons = {
          --   corner = "└ ",
          --   edge = "│ ",
          --   item = "│ ",
          --   bottom = "─ ",
          --   none = "  ",
          -- },
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          -- Requires a Nerd Font installed and configured in your terminal
          glyphs = {
            default = '󰈚', -- Default icon
            symlink = '', -- Symlink icon
            folder = {
              default = '', -- Default folder icon
              open = '', -- Icon for an open folder
              empty = '󰜌', -- Icon for an empty folder
              empty_open = '󰜌', -- Icon for an open empty folder
              symlink = '', -- Symlink folder icon
            },
            git = {
              unstaged = '󰄱', -- Git unstaged icon
              staged = '✓', -- Git staged icon
              unmerged = '', -- Git unmerged icon
              renamed = '➜', -- Git renamed icon
              untracked = 'U', -- Git untracked icon (or use "★" or "?")
              deleted = '', -- Git deleted icon
              ignored = '◌', -- Git ignored icon
            },
          },
        },
      },

      -- Filtering options
      filters = {
        dotfiles = false, -- Set to true to show dotfiles by default
        custom = { '.git', 'node_modules', '.cache' }, -- Hide these folders/files
        exclude = {}, -- List of regex patterns to exclude
      },

      -- Git integration options
      git = {
        enable = true,
        ignore = true, -- Set to false to show gitignored files by default
        timeout = 400,
      },

      -- Logging level (trace, debug, info, warn, error)
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },

      -- Other settings
      trash = { -- Send deleted files to trash instead of permanently deleting
        cmd = 'trash', -- Requires 'trash-cli' to be installed (or 'gio trash' on Linux)
        require_confirm = true,
      },
      live_filter = { -- Settings for live filtering
        prefix = '[FILTER]: ',
        always_show_folders = true,
      },
      -- Add any other specific nvim-tree options you need.
      -- Refer to :help nvim-tree-setup for all available options.
    }

    -- Global keymaps to interact with NvimTree (outside the NvimTree window)
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true, desc = 'NvimTree' }

    keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree explorer' })
    keymap('n', '<C-b>', ':NvimTreeFocus<CR>', { desc = 'Focus NvimTree explorer' })
    -- Example: Alternative toggle if you prefer Ctrl+n
    -- keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree (alternative)" })

    print 'NvimTree setup complete with custom copy path keymaps.'
  end,
}
