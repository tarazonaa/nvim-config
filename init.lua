local vim = vim
local o = vim.opt
local g = vim.g

-- options
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true
o.wrap = false
o.autoread = false
o.signcolumn = 'yes'
o.backspace = 'indent,eol,start'
o.completeopt = { 'menu', 'menuone', 'noselect', 'popup', 'fuzzy' }
o.relativenumber = true
o.pumheight = 15
o.undofile = true
o.ignorecase = true
o.smartcase = true
o.swapfile = false
o.foldmethod = 'indent'
o.foldlevelstart = 99

-- globals
g.mapleader = ' '
g.maplocalleader = ' '

local opts = { silent = true }
local map = vim.keymap.set

-- splits
map('n', '<C-k>', '<cmd>wincmd k<cr>', opts)
map('n', '<C-j>', '<cmd>wincmd j<cr>', opts)
map('n', '<C-h>', '<cmd>wincmd h<cr>', opts)
map('n', '<C-l>', '<cmd>wincmd l<cr>', opts)

-- misc
map('n', '<leader>d', ':DiffviewOpen ')
map('n', '-', function()
  MiniFiles.open()
end)
map('n', '<leader>f', '<cmd>Pick files<cr>')
map('n', '<leader>g', '<cmd>Pick grep_live<cr>')

local augroup = vim.api.nvim_create_augroup('antarso.cfg', { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- plugins
vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-mini/mini.nvim',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  'https://github.com/Saghen/blink.cmp',
  'https://github.com/Saghen/blink.lib',

  'https://github.com/karb94/neoscroll.nvim',
  'https://github.com/linrongbin16/gitlinker.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/jaeheonji/catppuccin-nvim',
}

-- colorscheme
require('catppuccin').setup()
vim.cmd.colorscheme 'catppuccin'

-- treesitter
local function setup_ts()
  local ts_parsers = {
    'bash',
    'c',
    'dockerfile',
    'fish',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitcommit',
    'gitignore',
    'go',
    'gomod',
    'gosum',
    'html',
    'javascript',
    'json',
    'lua',
    'make',
    'markdown',
    'python',
    'rust',
    'elixir',
    'sql',
    'toml',
    'tsx',
    'typescript',
    'typst',
    'vim',
    'yaml',
    'zig',
  }

  local nts = require 'nvim-treesitter'

  nts.install(ts_parsers)

  autocmd('PackChanged', {
    callback = function()
      nts.update()
    end,
  })

  autocmd('FileType', {
    group = augroup,
    callback = function(args)
      local lang = vim.treesitter.language.get_lang(args.match)
      if not lang then
        return
      end

      if not pcall(vim.treesitter.language.add, lang) then
        return
      end

      if lang and pcall(vim.treesitter.language.add, lang) then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        vim.treesitter.start()
      end
    end,
  })
end

-- lsp
local function setup_lsp()
  vim.lsp.enable {
    'gopls',
    'ts_ls',
    'zls',
    'elixirls',
  }

  autocmd('LspAttach', {
    group = augroup,
    callback = function(ev)
      local bufopts = {
        noremap = true,
        silent = true,
        buffer = ev.buf,
      }

      map('n', 'gd', vim.lsp.buf.definition, bufopts)
      map('n', 'gr', vim.lsp.buf.references, bufopts)
      map('n', 'K', vim.lsp.buf.hover, bufopts)
      map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
      map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    end,
  })

  autocmd('BufWritePre', {
    group = augroup,
    callback = function(ev)
      vim.lsp.buf.format { bufnr = ev.buf }
    end,
  })
end

-- blink
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },

    menu = {
      auto_show = true,
    },
  },

  signature = {
    enabled = true,
  },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
}

-- plugins setup
setup_ts()
setup_lsp()

require('gitlinker').setup()
require('diffview').setup { use_icons = false }

require('mini.pick').setup()
require('mini.files').setup()
require('mini.surround').setup()
require('mini.snippets').setup()

require('neoscroll').setup()
