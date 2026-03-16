return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  event = {
    'BufReadPre /Users/moreh/Documents/Duong (local)/**.md',
    'BufNewFile /Users/moreh/Documents/Duong (local)/**.md',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  init = function()
    -- Required for Obsidian UI features
    vim.opt.conceallevel = 2
  end,
  opts = {
    -- Disables the old CamelCase commands and suppresses the warning
    legacy_commands = false,

    workspaces = {
      {
        name = 'Duong-local',
        path = '/Users/moreh/Documents/Duong (local)',
      },
    },

    ui = {
      enable = true,
      update_debounce = 200,
    },

    note_id_func = function(title)
      local suffix = ''
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,

    new_notes_location = 'current_dir',

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
  },
  keys = {
    -- FIX: Updated all keymaps to use the new `:Obsidian <subcommand>` syntax
    { '<leader>on', '<cmd>Obsidian new<cr>', desc = 'New Obsidian Note' },
    { '<leader>os', '<cmd>Obsidian search<cr>', desc = 'Search Obsidian' },
    { '<leader>oq', '<cmd>Obsidian quick_switch<cr>', desc = 'Quick Switch' },

    -- Subcommands inferred from the new documentation structure
    { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = 'Show Backlinks' },
    { '<leader>ot', '<cmd>Obsidian new_from_template<cr>', desc = 'New from Template' },

    -- Added based on the top-level commands you provided
    { '<leader>od', '<cmd>Obsidian today<cr>', desc = "Today's Daily Note" },
  },
}
