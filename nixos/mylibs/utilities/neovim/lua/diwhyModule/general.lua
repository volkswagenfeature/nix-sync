-- Faster diagnostic display
vim.o.updatetime = 1000

-- Show diagnostic when hovering on line.
vim.api.nvim_create_autocmd( 'CursorHold', {
   callback = function (args)
       vim.diagnostic.open_float()
   end
})
