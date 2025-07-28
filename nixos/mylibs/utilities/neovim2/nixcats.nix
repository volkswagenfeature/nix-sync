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
        lspsAndRuntimeDeps = with pkgs; {
	  general = [ripgrep universal-ctags]; # vim.health requests ripgrep.
          completion = {
            nixdev = [ nix-doc nixd nil ];
            luadev = [ lua-language-server ];
          };
	  highlighting = [gcc clang zig tree-sitter nodejs ];
        };
        optionalPlugins = with pkgs.vimPlugins; {
	        general = [ ];
          completion = { 
            general = [
              blink-cmp
	            nvim-surround # Not set up
            ];
            luadev = [ lazydev-nvim ];
          };
	  highlighting = {
	    treesitter = [
	      nvim-treesitter-textobjects
	      nvim-treesitter.withAllGrammars
	    ];
	    extras = [
	      rainbow-delimiters-nvim
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

        };

        startupPlugins = with pkgs.vimPlugins; {
	        general = [ ];
          completion = {
            general = [ nvim-lspconfig ];
          };
          loaders = [
            lze
            lzextras
            vim-repeat
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
          };
        };
      };
    };
  };

}
