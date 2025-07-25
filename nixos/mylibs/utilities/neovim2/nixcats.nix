{
 config,
 lib,
 inputs,
 pkgs,
 ...
}: let

nvimplug-overlay = final: prev : builtins.trace "???" {foo="bar";}; 
/*
{
  plugins-hawtkeys = 
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      lua,
    }:
    buildLuarocksPackage {
      pname = "plugins-hawtkeys";
      version = "scm-1";
      src = fetchFromGitHub {
        owner = "tris203";
        repo = "hawtkeys.nvim";
        rev = "main";
        hash = "";
      }; 
    };
};
*/

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
	        general = [
	          plenary-nvim
	        ];
          completion = [
            blink-cmp
	          lazydev-nvim
	          nvim-surround # Not set up
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
	  userExperience ={ 
	    uiAdditions = [
	      gitsigns-nvim 
	      # lualine-nvim # To set up later.
	      which-key-nvim
        ( mkPlugin "hawtkeys" (builtins.fetchGit {
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
