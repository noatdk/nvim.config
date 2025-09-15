vim.loader.enable()
--vim.cmd 'lang ja_JP.UTF-8'

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.g.node_host_prog = '~/.nvm/versions/node/v21.7.3/lib/node_modules/'

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

-- [[ setting options ]]
-- see `:help vim.opt`
-- note: you can change these options as you wish!
--  for more options, you can see `:help option-list
vim.opt.title = true
vim.opt.titlelen = 0 -- do not shorten title
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a'

vim.opt.foldenable = false
vim.opt.foldlevel = 20

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 300

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

if vim.fn.has 'wsl' == 1 then
  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = 'win32yank.exe -i --crlf',
      ['*'] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ['+'] = 'win32yank.exe -o --lf',
      ['*'] = 'win32yank.exe -o --lf',
    },
    cache_enabled = true,
  }
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

function _G.insert_full_path()
  local filepath = vim.fn.expand '%'
  vim.fn.setreg('+', filepath) -- write to clippoard
end

vim.keymap.set('n', '<leader>cp', insert_full_path, { noremap = true, silent = true, desc = '[C]opy File [P]ath' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- toggle diagnostic virtual text keymap
vim.keymap.set('n', '<leader>td', function()
  vim.diagnostic.config { virtual_text = not vim.diagnostic.config().virtual_text }
end, { desc = '[T]oggle [D]iagnostic Virtual Text' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '-', '<cmd>Oil<CR>')

vim.keymap.set('n', 'gl', function()
  if vim.bo.filetype == 'toggleterm' then
    local line = vim.api.nvim_get_current_line()
    require('toggleterm.ui').goto_previous()
    require('fileline').gotoline_at_cursor(true, line)
    return
  end

  require('fileline').gotoline_at_cursor(true)
end, { desc = '[G]o to [L]ine' })

vim.api.nvim_set_keymap('c', '<CR>', '<Plug>(kensaku-search-replace)<CR>', { noremap = true, silent = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup {
  {
    'yorickpeterse/nvim-pqf',
    opts = {

      signs = {
        error = { text = 'E', hl = 'DiagnosticSignError' },
        warning = { text = 'W', hl = 'DiagnosticSignWarn' },
        info = { text = 'I', hl = 'DiagnosticSignInfo' },
        hint = { text = 'H', hl = 'DiagnosticSignHint' },
      },

      -- By default, only the first line of a multi line message will be shown.
      -- When this is true, multiple lines will be shown for an entry, separated by
      -- a space
      show_multiple_lines = false,

      -- How long filenames in the quickfix are allowed to be. 0 means no limit.
      -- Filenames above this limit will be truncated from the beginning with
      -- `filename_truncate_prefix`.
      max_filename_length = 0,

      -- Prefix to use for truncated filenames.
      filename_truncate_prefix = '[...]',
    },
  },
  {
    'klen/nvim-config-local',
    opts = {
      -- Default options (optional)
      -- Config file patterns to load (lua supported)
      config_files = { '.nvim.lua', '.nvimrc', '.exrc' },

      -- Where the plugin keeps files data
      hashfile = vim.fn.stdpath 'data' .. '/config-local',

      autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
      commands_create = true, -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalDeny)
      silent = true, -- Disable plugin messages (Config loaded/denied)
      lookup_parents = false, -- Lookup config files in parent directories
    },
  },
  -- {
  --   'pechorin/any-jump.vim',
  -- },
  -- {
  --   'romus204/referencer.nvim',
  --   config = function()
  --     require('referencer').setup {
  --       format = '%d',
  --       pattern = {
  --         '*.go',
  --       },
  --     }
  --   end,
  -- },
  { 'tpope/vim-sleuth', event = 'VeryLazy' }, -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-fugitive', event = 'VeryLazy' }, -- Git commands in the fugitive interface
  { 'tpope/vim-rhubarb', event = 'VeryLazy' }, -- Open line on remote repo
  {
    'noatdk/fileline.nvim',
    event = 'VeryLazy',
  },
  -- {
  --   'christoomey/vim-tmux-navigator',
  --   lazy = false,
  -- },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    -- lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require('kitty-scrollback').setup {
        {
          status_window = {
            enabled = false,
          },
          restore_options = true,
        },
      }
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'kitty-scrollback',
        callback = function()
          vim.schedule(function()
            vim.keymap.set('n', '<CR>', function()
              local fileline = require 'fileline'
              fileline.gotoline_at_cursor(true)
            end)
          end)
        end,
      })
    end,
  },
  -- { 'skywind3000/asyncrun.vim' },
  {
    'mg979/vim-visual-multi',
    event = 'VeryLazy',
  },
  -- {
  --   'amitds1997/remote-nvim.nvim',
  --   lazy = true,
  --   version = '*', -- Pin to GitHub releases
  --   dependencies = {
  --     'nvim-lua/plenary.nvim', -- For standard functions
  --     'MunifTanjim/nui.nvim', -- To build the plugin UI
  --     'nvim-telescope/telescope.nvim', -- For picking b/w different remote methods
  --   },
  --   config = true,
  -- },
  -- { 'Civitasv/cmake-tools.nvim', opts = {} },

  {
    'lambdalisue/kensaku-search.vim',
    dependencies = {
      { 'vim-denops/denops.vim', event = 'VeryLazy' },
      {
        'lambdalisue/kensaku.vim',
        event = 'VeryLazy',
      },
    },
    event = 'VeryLazy',
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      }
    end,
  },
  -- { 'folke/tokyonight.nvim' },
  {
    -- 'flazz/vim-colorschemes',
    'cseelus/vim-colors-clearance',
    event = 'UIEnter',
    config = function()
      vim.cmd.colorscheme 'clearance'
    end,
    -- opts = {
    --   transparent = true,
    --   styles = {
    --     sidebars = 'transparent',
    --     floats = 'transparent',
    --   },
    -- },
  },
  -- {
  --   'morhetz/gruvbox',
  -- },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VeryLazy', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { 'j-hui/fidget.nvim', opts = {}, event = 'VeryLazy' },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      columns = {
        'icon',
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local ignored = {
            '.DS_Store',
          }
          return vim.tbl_contains(ignored, name)
        end,
      },
    },
    -- Optional dependencies
    -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

  require 'custom.plugins.debug',
  require 'custom.plugins.indent_line',
  require 'custom.plugins.lint',
  require 'custom.plugins.autopairs',
  require 'custom.plugins.cmp',
  require 'custom.plugins.lsp',
  require 'custom.plugins.telescope',
  require 'custom.plugins.tree-sitter',
  require 'custom.plugins.format',
  require 'custom.plugins.toggleterm',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}
