return {
  'hat0uma/csvview.nvim',
  ---@module "csvview"
  ---@type CsvView.Options
  opts = {
    parser = {
      -- Treats lines starting with # or // as comments (not formatted as table)
      comments = { '#', '//' },
      delimiter = {
        ft = {
          csv = ',',
          tsv = '\t',
        },
      },
    },
    view = {
      -- "border" uses vertical lines │ for a cleaner spreadsheet look
      -- "highlight" just colors the existing commas
      display_mode = 'border',
      spacing = 2,
      -- Keeps the header row at the top while you scroll
      sticky_header = {
        enabled = true,
      },
    },
    keymaps = {
      -- Navigation: Tab through fields like Excel
      jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
      jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
      -- Enter to move down rows
      jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
      jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      -- Text Objects: Use 'if' for inner field, 'af' for a field with delimiter
      -- Example: 'dif' to delete inside a CSV cell
      textobject_field_inner = { 'if', mode = { 'o', 'x' } },
      textobject_field_outer = { 'af', mode = { 'o', 'x' } },
    },
  },
  -- Only load these commands when needed to keep startup fast
  cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
}
