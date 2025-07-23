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
        lspsAndRuntimeDeps = {
          completionEngines = [];
            
          general = [];
          
        };

        optionalPlugins = with pkgs.vimPlugins; {
          completionEngines = [
            blink-cmp
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
          };
        };
      };
    };
  };

}
