return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        --'php',
        --'blade',
        --'javascript',
        --'php_only',
      },
      textobjects = { enable = true },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        -- additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
      -- local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      ---@diagnostic disable-next-line: missing-fields
      -- parser_config.blade = {
      --   install_info = {
      --     url = 'https://github.com/EmranMR/tree-sitter-blade',
      --     files = { 'src/parser.c' },
      --     branch = 'main',
      --     generate_requires_npm = true,
      --     requires_generate_from_grammar = true,
      --   },
      --   filetype = 'blade',
      -- }

      -- vim.filetype.add {
      --   pattern = {
      --     ['.*%.blade%.php'] = 'blade',
      --   },
      -- }

      -- NOTE: disabling this since nvim-ufo already uses 'indent'
      --
      -- require('nvim-treesitter.configs').setup(opts)
      -- vim.api.nvim_create_autocmd({ 'FileType' }, {
      --   callback = function()
      --     if require('nvim-treesitter.parsers').has_parser() then
      --       vim.opt.foldmethod = 'expr'
      --       vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
      --     else
      --       vim.opt.foldmethod = 'syntax'
      --     end
      --   end,
      -- })

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      --
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      enable = true,
    },
  },
}
