-- lua/plugins/alpha.lua (or add to your main plugins file)
local function getLen(str, start_pos)
  local byte = string.byte(str, start_pos)
  if not byte then
    return nil
  end

  return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
end

local function colorize(header, header_color_map, colors)
  for letter, color in pairs(colors) do
    local color_name = 'AlphaJemuelKwelKwelWalangTatay' .. letter
    vim.api.nvim_set_hl(0, color_name, color)
    colors[letter] = color_name
  end

  local colorized = {}

  for i, line in ipairs(header_color_map) do
    local colorized_line = {}
    local pos = 0

    for j = 1, #line do
      local start = pos
      pos = pos + getLen(header[i], start + 1)

      local color_name = colors[line:sub(j, j)]
      if color_name then
        table.insert(colorized_line, { color_name, start, pos })
      end
    end

    table.insert(colorized, colorized_line)
  end

  return colorized
end

return {
  'goolord/alpha-nvim',
  event = 'VimEnter', -- Load it when Neovim starts and enters VimEnter event
  dependencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin/nvim' }, -- Optional: for icons
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard' -- Or require('alpha.themes.startify')

    local mocha = require('catppuccin.palettes').get_palette 'mocha'

    local header = {
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████                                   ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
      [[ ██████████████████████████████████████████████████████████████████████████████████████████████████████ ]],
    }

    local color_map = {
      [[ WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWWWWWWWWWWWWWW ]],
      [[ RRRRWWWWWWWWWWWWWWWWRRRRRRRRRRRRRRRRWWWWWWWWWWWWWWWWBBPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPBBWWWWWWWWWWWW ]],
      [[ RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRBBPPPPPPHHHHHHHHHHHHHHHHHHHHHHHHHHPPPPPPBBWWWWWWWWWW ]],
      [[ RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRBBPPPPHHHHHHHHHHHHFFHHHHFFHHHHHHHHHHPPPPBBWWWWWWWWWW ]],
      [[ OOOORRRRRRRRRRRRRRRROOOOOOOOOOOOOOOORRRRRRRRRRRRRRBBPPHHHHFFHHHHHHHHHHHHHHHHHHHHHHHHHHHHPPBBWWWWWWWWWW ]],
      [[ OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOBBPPHHHHHHHHHHHHHHHHHHHHBBBBHHHHFFHHHHPPBBWWBBBBWWWW ]],
      [[ OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOBBPPHHHHHHHHHHHHHHHHHHBBMMMMBBHHHHHHHHPPBBBBMMMMBBWW ]],
      [[ YYYYOOOOOOOOOOOOOOOOYYYYYYYYYYYYYYYYOOBBBBBBBBOOOOBBPPHHHHHHHHHHHHFFHHHHBBMMMMMMBBHHHHHHPPBBMMMMMMBBWW ]],
      [[ YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYBBMMMMBBBBOOBBPPHHHHHHHHHHHHHHHHHHBBMMMMMMMMBBBBBBBBMMMMMMMMBBWW ]],
      [[ YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYBBBBMMMMBBBBBBPPHHHHHHFFHHHHHHHHHHBBMMMMMMMMMMMMMMMMMMMMMMMMBBWW ]],
      [[ GGGGYYYYYYYYYYYYYYYYGGGGGGGGGGGGGGGGYYYYBBBBMMMMBBBBPPHHHHHHHHHHHHHHFFBBMMMMMMMMMMMMMMMMMMMMMMMMMMMMBB ]],
      [[ GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBMMMMBBPPHHFFHHHHHHHHHHHHBBMMMMMMCCBBMMMMMMMMMMCCBBMMMMBB ]],
      [[ GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBPPHHHHHHHHHHHHHHHHBBMMMMMMBBBBMMMMMMBBMMBBBBMMMMBB ]],
      [[ UUUUGGGGGGGGGGGGGGGGUUUUUUUUUUUUUUUUGGGGGGGGGGGGBBBBPPHHHHHHHHHHFFHHHHBBMMRRRRMMMMMMMMMMMMMMMMMMRRRRBB ]],
      [[ UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUBBPPPPHHFFHHHHHHHHHHBBMMRRRRMMBBMMMMBBMMMMBBMMRRRRBB ]],
      [[ UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUBBPPPPPPHHHHHHHHHHHHHHBBMMMMMMBBBBBBBBBBBBBBMMMMBBWW ]],
      [[ VVVVUUUUUUUUUUUUUUUUVVVVVVVVVVVVVVVVUUUUUUUUUUUUBBBBBBPPPPPPPPPPPPPPPPPPPPBBMMMMMMMMMMMMMMMMMMMMBBWWWW ]],
      [[ VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVBBMMMMMMBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBWWWWWW ]],
      [[ VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVBBMMMMBBBBWWBBMMMMBBWWWWWWWWWWBBMMMMBBWWBBMMMMBBWWWWWWWW ]],
      [[ WWWWVVVVVVVVVVVVVVVVWWWWWWWWWWWWWWWWVVVVVVVVVVBBBBBBBBWWWWBBBBBBWWWWWWWWWWWWWWBBBBBBWWWWBBBBWWWWWWWWWW ]],
    }

    local colors = {
      -- ['W'] = { fg = mocha.base },
      ['W'] = { fg = '#000000' },
      ['C'] = { fg = mocha.text },
      ['B'] = { fg = mocha.crust },
      ['R'] = { fg = mocha.red },
      ['O'] = { fg = mocha.peach },
      ['Y'] = { fg = mocha.yellow },
      ['G'] = { fg = mocha.green },
      ['U'] = { fg = mocha.blue },
      ['P'] = { fg = mocha.yellow },
      ['H'] = { fg = mocha.pink },
      ['F'] = { fg = mocha.red },
      ['M'] = { fg = mocha.overlay0 },
      ['V'] = { fg = mocha.lavender },
    }

    dashboard.section.header.val = header
    dashboard.section.header.opts = {
      hl = colorize(header, color_map, colors),
      position = 'center',
    }

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

    for _, a in ipairs(dashboard.section.buttons.val) do
      a.opts.width = 49
      a.opts.cursor = -2
    end

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
