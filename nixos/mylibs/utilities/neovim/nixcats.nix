{
 config,
 lib,
 inputs,
 pkgs,
 ...
}: let

nvimplug-overlay = final: prev : builtins.trace "???" {foo="bar";}; 
traceValShort = v : (builtins.trace (toString v) v );
in {
  imports = [
    inputs.nixCats.nixosModules.default
  ];
  config = {
    nixCats = {
      enable = true;
      packageNames = [ "diwhyModule" ];
      luaPath = ./.;

      categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {

        extraLuaPackages = {
          general = [ 
            (lp: [lp.lyaml])
          ];
        };

        lspsAndRuntimeDeps = with pkgs; {
          general = [ripgrep universal-ctags]; # vim.health requests ripgrep.
          completion = {
            nixdev = [ nix-doc nixd nil ];
            luadev = [ lua-language-server ];
            pydev  = [ basedpyright];
          };
          highlighting = [gcc clang zig tree-sitter nodejs ];
          llmInter = [llm];
        };
        optionalPlugins = with pkgs.vimPlugins; {
          general = [ ];
          completion = { 
            general = [
              blink-cmp
            ];
            luadev = [ lazydev-nvim ];
          };
          highlighting = {
            treesitter = [
              nvim-treesitter-textobjects
              nvim-treesitter.withAllGrammars
            ];
            delimiters = [
              rainbow-delimiters-nvim
              indent-blankline-nvim
              nvim-autopairs
              nvim-surround
            ];
          };
          userExperience = { 
            uiAdditions = [
              gitsigns-nvim 
              # lualine-nvim # To set up later.
              which-key-nvim
              plenary-nvim
              (mkPlugin "hawtkeys.nvim" (builtins.fetchGit {
                url = "https://github.com/tris203/hawtkeys.nvim";
                rev = "261cc311d4abdc88decceca6dc1013faa14c56ea";
              }))
            ];
            misc = [
              undotree
            ];
          };
          llmInter = [
            ( mkPlugin "sllm.nvim" ( builtins.fetchGit {
              url = "https://github.com/mozanunal/sllm.nvim";
              rev = "f327578f9c866b5e9c4301716370359479e7d159";
            }))
          ];
        };

        startupPlugins = with pkgs.vimPlugins; {
          general = [ fugitive statuscol-nvim mini-base16];
          completion = {
            general = [ nvim-lspconfig ];
          };
          loaders = [
            lze
            lzextras
            vim-repeat
            vim-startuptime
          ];
        };

        sharedLibraries = {
          general = [];
        };

        environmentVariables = {
          CATTESTVAR = "kekekeke";
        };
      });

      packageDefinitions.replace = {
        diwhyModule = {pkgs, name, ...}:{
          settings = {
            suffix-path = true;
            suffix-LD = true;
            #wrapRc = false;
            aliases = ["vim" "nvim"];
          };
          categories = {
            general = true;
            loaders = true;
            highlighting = true;
            completion = true;
            userExperience = true;
            llmInter = true;
            colors = config.lib.stylix.colors;

          };

        };
      };
    };
  };

}
