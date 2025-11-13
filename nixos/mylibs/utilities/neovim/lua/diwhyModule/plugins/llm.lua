return {
    {
        "sllm",
        after = function (plugin)
            require("sllm").setup({})
        end
    }
}
