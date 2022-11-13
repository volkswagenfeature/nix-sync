{lib, pkgs, config, ...}:
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
           #Completion
           rainbow 
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
  ];
  programs.vim.defaultEditor = true;
}
