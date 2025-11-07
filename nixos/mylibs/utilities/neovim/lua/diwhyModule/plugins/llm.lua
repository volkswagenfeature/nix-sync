return {
    {
        "sllm.nvim",
        after = function (plugin)
            require("sllm").setup({})
        end
    }
}
