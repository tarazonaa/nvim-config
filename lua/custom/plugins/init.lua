-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    'elixir-tools/elixir-tools.nvim',
    version = '*',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local elixir = require 'elixir'
      local elixirls = require 'elixir.elixirls'

      elixir.setup {
        nextls = { enable = true, filetypes = { 'elixir', 'heex' } },
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
          on_attach = function(client, bufnr)
            vim.keymap.set('n', '<space>fp', ':ElixirFromPipe<cr>', { buffer = true, noremap = true })
            vim.keymap.set('n', '<space>tp', ':ElixirToPipe<cr>', { buffer = true, noremap = true })
            vim.keymap.set('v', '<space>em', ':ElixirExpandMacro<cr>', { buffer = true, noremap = true })
          end,
        },
        projectionist = {
          enable = true,
        },
      }
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kkharji/sqlite.lua', -- Optional, sqlite support
    },
  },
  {
    'aserowy/tmux.nvim',
    config = function()
      require('tmux').setup()
    end,
  },
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'

      nvim_tmux_nav.setup {
        disable_when_zoomed = true, -- defaults to false
      }

      vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
      vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
      vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateNext)
    end,
  },
  {
    'stevearc/oil.nvim',
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          autosave_changes = false,
        },
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<space>-', require('oil').toggle_float)
    end,
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    'xiyaowong/transparent.nvim',
    config = function()
      require('transparent').setup()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
  {
    'cdmill/neomodern.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('neomodern').setup {
        -- optional configuration here
      }
      require('neomodern').load()
    end,
  },
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      local crates = require 'crates'
      local opts = { silent = true }

      vim.keymap.set('n', '<leader>ct', crates.toggle, opts)
      vim.keymap.set('n', '<leader>cr', crates.reload, opts)

      vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, opts)
      vim.keymap.set('n', '<leader>cf', crates.show_features_popup, opts)
      vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, opts)

      vim.keymap.set('n', '<leader>cu', crates.update_crate, opts)
      vim.keymap.set('v', '<leader>cu', crates.update_crates, opts)
      vim.keymap.set('n', '<leader>ca', crates.update_all_crates, opts)
      vim.keymap.set('n', '<leader>cU', crates.upgrade_crate, opts)
      vim.keymap.set('v', '<leader>cU', crates.upgrade_crates, opts)
      vim.keymap.set('n', '<leader>cA', crates.upgrade_all_crates, opts)

      vim.keymap.set('n', '<leader>cx', crates.expand_plain_crate_to_inline_table, opts)
      vim.keymap.set('n', '<leader>cX', crates.extract_crate_into_table, opts)

      vim.keymap.set('n', '<leader>cH', crates.open_homepage, opts)
      vim.keymap.set('n', '<leader>cR', crates.open_repository, opts)
      vim.keymap.set('n', '<leader>cD', crates.open_documentation, opts)
      vim.keymap.set('n', '<leader>cC', crates.open_crates_io, opts)
      vim.keymap.set('n', '<leader>cL', crates.open_lib_rs, opts)

      crates.setup {
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
  {
    'bezhermoso/tree-sitter-ghostty',
    build = 'make nvim_install',
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
    keys = {
      { '<leader>dvo', '<cmd>DiffviewOpen<cr>', desc = 'Diffview Open' },
      { '<leader>dvc', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
      { '<leader>dvh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview File History' },
    },
    opts = {},
  },
}
