require("diwhyModule.tabsettings")
require("diwhyModule.LSPs")

require('lze').load {
    { import = "diwhyModule.plugins.treesitter" },
    { import = "diwhyModule.plugins.blink-cmp"  },
    { import = "diwhyModule.plugins.gitsigns"   },
    { import = "diwhyModule.plugins.which-key"  },
    {
      "rainbow-delimiters.nvim",
      lazy = false,
      after = function(plugin)
        require("rainbow-delimiters.setup").setup({})
      end,
    },
    { 
      "hawtkeys.nvim",
      cmd = {"Hawtkeys","HawtkeysAll","HawtkeysDupes"},
      load = function (plugin)
        vim.cmd.packadd("plenary.nvim")
        vim.cmd.packadd(plugin)
      end,
      after = function (plugin)
        require("hawtkeys").setup({})
      end,
    }
}

