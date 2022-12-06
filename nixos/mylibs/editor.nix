{lib, pkgs, config, inputs, ...}:
with lib;
{
  environment.systemPackages = with pkgs; [ 
    ((vim_configurable.override { }).customize {
      name = "vim";    
      vimrcConfig = {

        beforePlugins = ''
             set nocompatible
             filetype plugin indent on
        '';
        customRC = ''
             "Compat options
             set nocompatible

             "Default tab settings
             set smartindent
             set tabstop=4 shiftwidth=4 expandtab softtabstop=4

             "Savefile options:


             "Interface specifics
             set ruler
             set number
             set background=dark
             set hlsearch
             set smartindent
             syntax enable

        '';
      };

      vimrcConfig.packages.customize = with pkgs.vimPlugins; {
        start = [
          #Language highlighting
          indentLine
          rainbow 
          vim-nix

          #Completion
          vim-repeat 
          vim-surround 
          lexima-vim

          #Navigation
          vim-signature 
          ctrlp 
          nerdtree
          #Syncronization
        ];
      }; 
    })

    #( inputs.nixvim.build pkgs { })
  ];
  programs.vim.defaultEditor = true;

  # don't think these do anything at the moment.
  #programs.neovim.vimAlias = false;
  #programs.neovim.viAlias  = false;

  programs.nixvim={
    enable = true;
    #vimAlias = false;
    #viAlias = false;
    options = {
        nocompatible = true;
        # Default indenting
        smartindent = true;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        softtabstop = 4;
        number = true;
        ruler  = true;
        hlsearch = true;
        syntax = true;
        
        background = "dark";
        colorcolumn = 80;
    };
    globals = {
      clipboard = {
        name = "Testclip";
        copy = {
          "+" = ["xclip"];
          "*" = ["xclip"];
        };
        paste = {
          "+" = ["xclip"];
          "*" = ["xclip"];
        };
        cache_enabled = true;
      };
    };
    extraPackages = [pkgs.xclip];
    plugins = {
      nix.enable = true;
      nvim-autopairs.enable = true;
      treesitter.enable = true;

      treesitter.ensureInstalled = [
        "nix"
      ];

      lsp = {
        enable = true;
        servers = {
          rnix-lsp.enable = true;
          pyright.enable = true;
        };
      };
    };
    extraPlugins = [
          #Language highlighting
          pkgs.vimPlugins.indentLine
          pkgs.vimPlugins.rainbow 
          #pkgs.vimPlugins.vim-nix

          #Completion
          pkgs.vimPlugins.vim-repeat 
          pkgs.vimPlugins.vim-surround 
          pkgs.vimPlugins.lexima-vim

          #Navigation
          pkgs.vimPlugins.vim-signature 
          pkgs.vimPlugins.ctrlp 
          pkgs.vimPlugins.nerdtree
          #Syncronization
        ];
  };
}
