return {
  'obsidian-nvim/obsidian.nvim',
  event = 'VeryLazy',
  version = '*', -- recommended, use latest release instead of latest commit
  ft = 'markdown',
  dependencies = {
    {
      'oflisback/obsidian-bridge.nvim',
      opts = {
        -- your config here
      },
      event = {
        'BufReadPre *.md',
        'BufNewFile *.md',
      },
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
    },
  },
  keys = {
    { '<leader>oo', '<cmd>ObsidianOpen<cr>', desc = 'Open Obsidian' },
    { '<leader>on', '<cmd>ObsidianNew<cr>', desc = 'Create a new Obsidian Document' },
    { '<leader>os', '<cmd>ObsidianSearch<cr>', desc = 'Search Obsidian' },
    { '<leader>of', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Obsidian Find Files' },
    { '<leader>op', '<cmd>ObsidianPasteImg<cr>', desc = 'Obsidian Paste Image' },
    { '<leader>or', '<cmd>ObsidianRename<cr>', desc = 'Obsidian Rename current note' },
    { '<leader>ot', '<cmd>ObsidianTemplate<cr>', desc = 'Insert Obsidian Template into file' },
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    ui = {
      enable = true,
    },
    daily_notes = {
      folder = 'nikki',
      default_tags = { '日記' },
      workdays_only = false,
    },
    workspaces = {
      {
        name = 'nikki',
        path = '~/Documents/nikki/にっき/',
      },
    },
    note_id_func = function(title)
      if title ~= nil then
        -- Convert title to lowercase and replace spaces with hyphens, e.g. "My Note" -> "my-note"
        return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        return 'untitled'
      end
    end,
  },
}
