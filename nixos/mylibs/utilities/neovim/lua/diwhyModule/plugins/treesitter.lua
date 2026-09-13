-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- NOTE: NixOS 26.05 ships the rewritten ("main" branch) nvim-treesitter.
-- In that version the old `require('nvim-treesitter.configs').setup{...}` API
-- no longer exists. Highlighting/indentation are now provided by Neovim itself
-- (enabled via autocommands) and textobjects are configured through their own
-- `nvim-treesitter-textobjects` plugin.
return {
  {
    "nvim-treesitter",
    for_cat = 'general.treesitter',
    -- cmd = { "" },
    event = "DeferredUIEnter",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    load = function (plugin)
        vim.cmd.packadd(plugin)
        vim.cmd.packadd("nvim-treesitter-textobjects")
    end,
    after = function (plugin)
      -- Disable the built-in textobject mappings so ours (below) win.
      vim.g.no_plugin_maps = true

      -- Treesitter highlighting is a Neovim feature now; enable it for every
      -- buffer whose filetype has a parser available.
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          -- `start` throws when no parser is installed for the buffer.
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      -- Textobjects now live in their own plugin (select/move/swap).
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        move = {
          -- whether to set jumps in the jumplist
          set_jumps = true,
        },
      }

      local select = require('nvim-treesitter-textobjects.select')
      local move = require('nvim-treesitter-textobjects.move')
      local swap = require('nvim-treesitter-textobjects.swap')

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = desc })
      end

      -- Select (use the capture groups defined in textobjects.scm)
      map({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end, 'Select parameter (outer)')
      map({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end, 'Select parameter (inner)')
      map({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end, 'Select function (outer)')
      map({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end, 'Select function (inner)')
      map({ 'x', 'o' }, 'ac', function() select.select_textobject('@class.outer', 'textobjects') end, 'Select class (outer)')
      map({ 'x', 'o' }, 'ic', function() select.select_textobject('@class.inner', 'textobjects') end, 'Select class (inner)')

      -- Move
      map({ 'n', 'x', 'o' }, ']m', function() move.goto_next_start('@function.outer', 'textobjects') end, 'Next function start')
      map({ 'n', 'x', 'o' }, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end, 'Next class start')
      map({ 'n', 'x', 'o' }, ']M', function() move.goto_next_end('@function.outer', 'textobjects') end, 'Next function end')
      map({ 'n', 'x', 'o' }, '][', function() move.goto_next_end('@class.outer', 'textobjects') end, 'Next class end')
      map({ 'n', 'x', 'o' }, '[m', function() move.goto_previous_start('@function.outer', 'textobjects') end, 'Previous function start')
      map({ 'n', 'x', 'o' }, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end, 'Previous class start')
      map({ 'n', 'x', 'o' }, '[M', function() move.goto_previous_end('@function.outer', 'textobjects') end, 'Previous function end')
      map({ 'n', 'x', 'o' }, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end, 'Previous class end')

      -- Swap
      map('n', '<leader>a', function() swap.swap_next('@parameter.inner') end, 'Swap with next parameter')
      map('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end, 'Swap with previous parameter')
    end,
  },
}
