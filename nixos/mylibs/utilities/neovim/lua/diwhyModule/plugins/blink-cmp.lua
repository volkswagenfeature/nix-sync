return {
    {
        -- stolen from: https://github.com/dliberalesso/nix-config/blob/e89c29e5d37cdcbba29334ec04d693c9af81b1f9/modules/nvim/init.lua
        "blink.cmp",
        enabled = nixCats("general") or false,
        event = "DeferredUIEnter",
        on_require = "blink",
        dep_of = {"lazydev.nvim"},
        load = function(plugin)
            vim.cmd.packadd(plugin)
        end,
        after = function(plugin)
            require("blink.cmp").setup({
                keymap = { preset = "enter" },
                appearance = { nerd_font_variant = "mono" },
                signature = { enabled = true },
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                    per_filetype = {
                        lua = { inherit_defaults = true, "lazydev" },
                    },
                    providers = {
                        lazydev = {
                            name = "lazydev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        }
                    },
                },
            })
        end
    },
    {
        -- lazydev makes your lsp way better in your config without needing extra lsp configuration.
        "lazydev.nvim",
        for_cat = "completion.luadev",
        -- Disabled mostly so blink.cmp can pass the health checks on non-lua
        -- filetypes
        -- ft = "lua",
        -- cmd = { "LazyDev" },
        after = function(_)
          require('lazydev').setup({
            library = {
              { words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. '/lua' },
            },
          })
        end,
    }
}
