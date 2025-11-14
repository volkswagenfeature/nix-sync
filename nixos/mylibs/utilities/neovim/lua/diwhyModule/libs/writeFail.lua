
CATCH_ERRORS = {"E212", "E505"}
local M = {}

function attempt_sudo_write(args)
    vim.notify("Hello!")
    return
end



function M.setup(opts)
    --vim.api.nvim_create_autocmd("CmdlineLeave",)
    vim.api.nvim_create_autocmd({ "FileWriteCmd","BufWriteCmd" },{
        callback = function (args) 
            

        end

    })
end

return M
