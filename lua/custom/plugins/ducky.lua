-- lua/plugins/ducky.lua

return {
  'kwakzalver/duckytype.nvim',
  config = function()
    require('duckytype').setup()
  end,
}
