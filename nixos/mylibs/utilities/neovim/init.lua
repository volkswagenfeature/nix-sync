-- Additional modules
require("diwhyModule.tabsettings")
require("diwhyModule.LSPs")
require("diwhyModule.general")

local function parse_base_keys(path)
  local bases = {}
  for line in io.lines(path) do
    -- match: key : value   (allowing spaces)
    local key, val = line:match("^%s*([%w_%-]+)%s*:%s*(.-)%s*$")
    if key and key:match("^base[%da-fA-F][%da-fA-F]$") then
      -- strip optional single/double quotes around the value
      val = val:gsub("^['\"](.*)['\"]$", "%1")
      bases[key] = val
    end
  end
  return bases
end 

Base16Colors = parse_base_keys(nixCats("colors"))

-- Plugin Loading
require('lze').load {
    { import = "diwhyModule.plugins.llm"},
    { import = "diwhyModule.plugins.treesitter"  },
    { import = "diwhyModule.plugins.blink-cmp"   },
    { import = "diwhyModule.plugins.gitsigns"    },
    { import = "diwhyModule.plugins.which-key"   },
    { import = "diwhyModule.plugins.indentation" },
    {
        "mini.base16",
        lazy = false,
        after = function (plugin)

            require("mini.base16").setup({
                palette = Base16Colors
            })
        end
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
    },
}

-- General configuration
--

require("diwhyModule.libs.writeFail").setup()
