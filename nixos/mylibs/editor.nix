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
  };
}
