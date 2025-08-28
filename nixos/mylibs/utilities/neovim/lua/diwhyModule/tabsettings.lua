vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.cindent = true

local progtab = function (tw)
    return function (args)
        vim.opt.tabstop = tw
        vim.opt.shiftwidth = tw
        vim.opt.expandtab = true
        vim.opt.cindent = true
    end
end

vim.api.nvim_create_autocmd( 'FileType',
    { pattern = {'python','lua'}, 
      callback = progtab(4)
    }
)
