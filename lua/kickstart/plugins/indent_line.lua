return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    config = function()
      require('ibl').setup {
        exclude = {
          buftypes = { 'terminal' },
        },
        indent = {
          char = '',
          tab_char = { 'a', 'b', 'c' },
          highlight = { 'Function', 'Label' },
          smart_indent_cap = true,
          priority = 1,
          repeat_linebreak = false,
        },
        scope = {
          enabled = true,
          highlight = { 'Function', 'Label' },
        },
      }
    end,
  },
}
