return {
    {
        "nvim-autopairs",
        enabled = nixCats("completion.delimiters"),
        after = function (plugin)
           require("nvim-autopairs").setup({
               check_ts = nixCats("highlighting.treesitter")
           })
        end
    },
    {
        "nvim-surround",
        enabled = nixCats("completion.delimiters"),
        after = function (plugin)
           require("nvim-surround").setup({
           })
        end
    },
    {
        "indent-blankline.nvim",
        enabled = nixCats("completion.delimiters"),
        event = "DeferredUIEnter",
        after = function (plugin)
           require("ibl").setup({
           })
        end
    },
    {
       "rainbow-delimiters",
        lazy = false,
        enabled = nixCats("completion.delimiters"),
        after = function (plugin)
           require("rainbow-delimiters.setup").setup({
           })
        end
    }
}
