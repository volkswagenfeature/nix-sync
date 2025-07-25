{
 config,
 lib,
 inputs,
 ...
}: let
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
          completion = [ ];
	  highlighting = [gcc clang zig tree-sitter nodejs ];
	  
          
        };

        optionalPlugins = with pkgs.vimPlugins; {
          completion = [
            blink-cmp
	    lazydev-nvim
          ];
	  highlighting = {
	    treesitter = [
	      nvim-treesitter-textobjects
	      nvim-treesitter.withAllGrammars
	    ];
	    extras = [
	      rainbow-delimiters-nvim
	    ];

	  };
        };

        startupPlugins = with pkgs.vimPlugins; {
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
          };
        };
      };
    };
  };

}
