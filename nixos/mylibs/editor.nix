{lib, pkgs, config, ...}:
with lib;
{
    environment.systemPackages = with pkgs; [ vim_configurable ];
    programs.vim.defaultEditor = true;
    vim_configurable.customize {
      	
       vimrcConfig {

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

       '';
       };

       vimrcConfig.packages.customize = with pkgs.vimPlugins {
	   #Completion
           start = [rainbow vim-repeat vim-surround lexima ];
	   #Navigation
	   start = [vim-signature ctrlp nerdtree];
           #Syncronization
           

	   

       } 

    }
}
