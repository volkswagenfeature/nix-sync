-- Additional modules
require("diwhyModule.tabsettings")
require("diwhyModule.LSPs")
require("diwhyModule.general")

-- Plugin Loading
require('lze').load {
    { import = "diwhyModule.plugins.treesitter"  },
    { import = "diwhyModule.plugins.blink-cmp"   },
    { import = "diwhyModule.plugins.gitsigns"    },
    { import = "diwhyModule.plugins.which-key"   },
    { import = "diwhyModule.plugins.indentation" },
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
    },
}

-- General configuration

