return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    -- you can enable a preset theme here, or configure styles manually
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = false, -- position command vertically and centered
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    -- add any options here
    cmdline = {
      enabled = true, -- enables Noice cmdline UI
      view = 'cmdline_popup', -- Use the popup view for the command line
      -- Position options to center the popup relative to the editor
      position = {
        relative = 'editor', -- Center relative to the editor window
        row = '50%', -- Center vertically
        col = '50%', -- Center horizontally
      },
      -- size = { -- Example size configuration if needed
      --   width = "80%",
      --   height = "auto",
      -- },
      format = { -- Customize the format of the cmdline view content (icons, etc.)
        -- cmdline = { pattern = "^:", icon = "", lang = "vim" },
        -- search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        -- search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        -- filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        -- lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        -- help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
        -- input = {}, -- Used default
      },
    },
    messages = {
      enabled = false, -- disabled messages UI as requested previously
    },
    -- popupmenu = {
    --  enabled = true, -- Optional: enable the Noice popup menu UI
    -- },
    -- routes = { -- Advanced: customize routing of messages
    --  {
    --    filter = { event = "msg_show", kind = "" },
    --    view = "messages",
    --  },
    -- },
  },
  -- stylua: ignore
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --  `nvim-notify` is only needed, if you want to use the notification view.
    --  If not available, we use `mini` priorities and pipes.
    "rcarriga/nvim-notify",
  }
,
  -- Removed trailing comma here
}
