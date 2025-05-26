return {
  -- Autocompletion Engine
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter', -- Load when entering insert mode
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      -- Source for integrating LuaSnip with nvim-cmp
      'saadparwaiz1/cmp_luasnip',

      -- Optional: Adds icons to completion items
      'onsails/lspkind.nvim',

      -- Optional: Other sources like cmdline, calculations, etc.
      -- 'hrsh7th/cmp-cmdline',
      -- 'hrsh7th/cmp-calc',
    },
    config = function()
      -- Basic configuration (see step 2)
      local cmp = require 'cmp'
      local lspkind = require 'lspkind' -- If using lspkind
      local luasnip = require('luasnip')
      cmp.setup {
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For luasnip users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For UltiSnips users.
            -- require('snippy').expand_snippet(args.body) -- For snippy users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),             -- Trigger completion
          ['<C-e>'] = cmp.mapping.abort(),                    -- Close completion
          ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept selected item using Ctrl+y
          ['<C-j>'] = cmp.mapping.select_next_item(),         -- Next suggestion using Ctrl+j
          ['<C-k>'] = cmp.mapping.select_prev_item(),         -- Previous suggestion using Ctrl+k
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then -- Check if we can jump in a snippet
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }), -- "i" for insert mode, "s" for select mode (visual selection in completion)
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then -- Check if we can jump back in a snippet
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        -- Optional: Add icons using lspkind
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',  -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from becoming too wide
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
            -- Show source name for each completion item
            -- Available options are: 'nvim_lsp', 'luasnip', 'buffer', 'path'
            before = function(entry, vim_item)
              -- You can modify vim_item here before it is displayed
              return vim_item
            end,
          },
        },
      }

      -- Setup for command line completion (optional)
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(
        ),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
  },

  -- Snippet Engine (if not included above)
  {
    'L3MON4D3/LuaSnip',
    -- follow latest release.
    version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- Optional: Pack of useful snippets
  },

  -- Other Dependencies (ensure they are listed if not included above)
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'saadparwaiz1/cmp_luasnip',
  'onsails/lspkind.nvim', -- Optional
}
