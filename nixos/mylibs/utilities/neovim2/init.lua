require('lze').load {
    { import = "diwhyModule.plugins.treesitter" },
    { import = "diwhyModule.plugins.blink-cmp"  },
    { import = "diwhyModule.plugins.gitsigns"   },
    { import = "diwhyModule.plugins.which-key"  },
    {
        -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
        "lazydev.nvim",
        for_cat = "neonixdev",
        cmd = { "LazyDev" },
        ft = "lua",
        after = function(_)
          require('lazydev').setup({
            library = {
              { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. '/lua' },
            },
          })
        end,
    },
    {
      "rainbow-delimiters.nvim",
      lazy = false,
      after = function(plugin)
        require("rainbow-delimiters.setup").setup({})
      end,
    },
    { "hawtkeys.nvim" }
}

