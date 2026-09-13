-- [[ Molten: interactive code evaluation with Jupyter kernels ]]
-- https://github.com/benlubas/molten-nvim
--
-- molten-nvim is a *remote* python plugin. nixCats generates its remote-plugin
-- manifest at build time (UpdateRemotePlugins) because (a) molten-nvim is placed
-- in startupPlugins (start) in nixcats.nix, and (b) settings.hosts.python3.enable
-- provides the python3 host (with pynvim) that the manifest builder scans against.
-- The Jupyter client and friends are installed into that host via
-- `python3.libraries.notebooks` in nixcats.nix.
return {
  {
    -- Image rendering backend used by molten's image provider.
    "image.nvim",
    enabled = nixCats("notebooks"),
    event = "DeferredUIEnter",
    load = function(plugin)
      vim.cmd.packadd(plugin)
    end,
    after = function(plugin)
      require("image").setup({
        -- The user's terminal is kitty (see mylibs/terminal.nix).
        backend = "kitty",
        -- Use the ImageMagick CLI (`magick`), added to PATH via lspsAndRuntimeDeps.
        -- (nixpkgs' image-nvim also propagates the `magick` lua rock, so you can
        -- switch this to "magick_rock" if you'd rather not depend on the binary.)
        processor = "magick_cli",
        -- Molten drives image rendering itself; disable image.nvim's own filetype
        -- integrations so markdown/asciidoc images aren't double-rendered.
        integrations = {},
        -- Safety caps (recommended by molten): prevent crashes on large images.
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      })
    end,
  },
  {
    -- Configure the (already start-loaded) remote plugin and its keymaps.
    "molten-nvim",
    enabled = nixCats("notebooks"),
    lazy = false,
    after = function(plugin)
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_output_win_max_height = 20

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- "<leader>n" is the [n]otebook prefix registered in which-key.lua.
      map("n", "<leader>ni", ":MoltenInit<CR>", "Initialize kernel")
      map("n", "<leader>ne", ":MoltenEvaluateOperator<CR>", "Evaluate operator")
      map("n", "<leader>nl", ":MoltenEvaluateLine<CR>", "Evaluate line")
      map("v", "<leader>nv", ":<C-u>MoltenEvaluateVisual<CR>gv", "Evaluate visual selection")
      map("n", "<leader>nr", ":MoltenReevaluateCell<CR>", "Re-evaluate cell")
      map("n", "<leader>no", ":noautocmd MoltenEnterOutput<CR>", "Open/enter output")
      map("n", "<leader>nh", ":MoltenHideOutput<CR>", "Hide output")
      map("n", "<leader>nd", ":MoltenDelete<CR>", "Delete cell")
      map("n", "<leader>nx", ":MoltenOpenInBrowser<CR>", "Open output in browser")
    end,
  },
}