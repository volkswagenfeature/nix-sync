{ config, lib, inputs, ... }: let
  inherit (inputs.nixCats) utils;
in {
  imports = [
    inputs.nixCats.nixosModules.default
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = {
      enable = true;
      # nixpkgs_version = inputs.nixpkgs;
      # this will add an overlay for any plugins
      # in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = [
        
      ];
      # see the packageDefinitions below.
      # This says which of those to install.
      packageNames = [ "myNixModuleNvim" ];

      luaPath = ./.;

      # the .replace vs .merge options are for modules based on existing configurations,
      # they refer to how multiple categoryDefinitions get merged together by the module.
      # for useage of this section, refer to :h nixCats.flake.outputs.categories
      categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {

        lspsAndRuntimeDeps = {
          # some categories of stuff.
          general = with pkgs; [
            universal-ctags
            ripgrep
            fd
          ];
          # these names are arbitrary.
          lint = with pkgs; [
          ];
          # but you can choose which ones you want
          # per nvim package you export
          debug = with pkgs; {
            go = [ delve ];
          };
          go = with pkgs; [
            gopls
            gotools
            go-tools
            gccgo
          ];
          # and easily check if they are included in lua
          format = with pkgs; [
          ];
          neonixdev = {
            # also you can do this.
            inherit (pkgs) nix-doc lua-language-server nixd;
            # and each will be its own sub category
          };
        };

        startupPlugins = {
          debug = with pkgs.vimPlugins; [
            nvim-nio
          ];
          general = with pkgs.vimPlugins; {
            # you can make subcategories!!!
            # (always isnt a special name, just the one I chose for this subcategory)
            always = [
              lze
              lzextras
              vim-repeat
              plenary-nvim
              nvim-notify
            ];
            extra = [
              oil-nvim
              nvim-web-devicons
            ];
          };
          # You can retreive information from the
          # packageDefinitions of the package this was packaged with.
          # :help nixCats.flake.outputs.categoryDefinitions.scheme
          themer = with pkgs.vimPlugins;
            (builtins.getAttr (categories.colorscheme or "onedark") {
                # Theme switcher without creating a new category
                "onedark" = onedark-nvim;
                "catppuccin" = catppuccin-nvim;
                "catppuccin-mocha" = catppuccin-nvim;
                "tokyonight" = tokyonight-nvim;
                "tokyonight-day" = tokyonight-nvim;
              }
            );
            # This is obviously a fairly basic usecase for this, but still nice.
        };

        optionalPlugins = {
          debug = with pkgs.vimPlugins; {
            # it is possible to add default values.
            # there is nothing special about the word "default"
            # but we have turned this subcategory into a default value
            # via the extraCats section at the bottom of categoryDefinitions.
            default = [
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
            ];
            go = [ nvim-dap-go ];
          };
          lint = with pkgs.vimPlugins; [
            nvim-lint
          ];
          format = with pkgs.vimPlugins; [
            conform-nvim
          ];
          markdown = with pkgs.vimPlugins; [
            markdown-preview-nvim
          ];
          neonixdev = with pkgs.vimPlugins; [
            lazydev-nvim
          ];
          general = {
            blink = with pkgs.vimPlugins; [
              luasnip
              cmp-cmdline
              blink-cmp
              blink-compat
              colorful-menu-nvim
            ];
            treesitter = with pkgs.vimPlugins; [
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
              # This is for if you only want some of the grammars
              # (nvim-treesitter.withPlugins (
              #   plugins: with plugins; [
              #     nix
              #     lua
              #   ]
              # ))
            ];
            telescope = with pkgs.vimPlugins; [
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              telescope-nvim
            ];
            always = with pkgs.vimPlugins; [
              nvim-lspconfig
              lualine-nvim
              gitsigns-nvim
              vim-sleuth
              vim-fugitive
              vim-rhubarb
              nvim-surround
            ];
            extra = with pkgs.vimPlugins; [
              fidget-nvim
              # lualine-lsp-progress
              which-key-nvim
              comment-nvim
              undotree
              indent-blankline-nvim
              vim-startuptime
              # If it was included in your flake inputs as plugins-hlargs,
              # this would be how to add that plugin in your config.
              # pkgs.neovimPlugins.hlargs
            ];
          };
        };

        # shared libraries to be added to LD_LIBRARY_PATH
        # variable available to nvim runtime
        sharedLibraries = {
          general = with pkgs; [
            # libgit2
          ];
        };
        environmentVariables = {
          test = {
            CATTESTVAR = "It worked!";
          };
        };
        extraWrapperArgs = {
          test = [
            '' --set CATTESTVAR2 "It worked again!"''
          ];
        };
        # lists of the functions you would have passed to
        # python.withPackages or lua.withPackages
        # get the path to this python environment
        # in your lua config via
        # vim.g.python3_host_prog
        # or run from nvim terminal via :!<packagename>-python3
        python3.libraries = {
          test = (_:[]);
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          test = [ (_:[]) ];
        };
      });

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        myNixModuleNvim = {pkgs, name, ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            # unwrappedCfgPath = "/path/to/config";
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = [ "nvim" ];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            format  = true;
            general = true;
            go = true;
          };
        };
      };
    };
  };
}
