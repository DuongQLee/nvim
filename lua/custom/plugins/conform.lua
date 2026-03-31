return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' }, -- Load plugin right before saving
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_format' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      json = { 'jq' },
      jsonc = { 'jq' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
    },
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 3000,
    },
  },
}
