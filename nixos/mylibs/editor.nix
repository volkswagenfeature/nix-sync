{lib, pkgs, config, inputs, ...}:
with lib;
{
  ### NEOVIM CONFIGS ###

  programs.nixvim={
    enable = true;

    # set up aliases
    viAlias = true;
    #vimdiffAlias = true;
    vimAlias = true;

    options = {
      # Default indenting
      smartindent = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      softtabstop = 4;
      # Should be on by default. Should be turned on by this option
      # Isn't.
      number = true;
      
      # Disabled in neovim, on by default
      #ruler  = true;
      #hlsearch = true;
      #syntax = true;
      # nocompatible = true;
      background = "dark";
      colorcolumn = "80";
      highlight = {
        # Doesn't work. Troubleshoot or workaround
        ColorColumn.ctermbg= "DarkGrey";
      };
      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable=true;
      };
    };
    globals = {};

    extraPackages = [pkgs.wl-clipboard-x11];
    plugins = {
      nix.enable = true;
      surround.enable = true;
      nvim-autopairs.enable = true;
      treesitter.enable = true;
      treesitter.ensureInstalled = [
        "nix"
      ];

      magma-nvim.enable = true;
      # coq-nvim.enable = true; # Not working as of 2023-02-25
      # nvim-cmp stolen wholesale from github.com/GaetanLepage/dotfiles
      # Path: /home/tui/neovim/completion.nix
      # kind of works... 
      nvim-cmp = {
        enable = true;

        snippet.expand = "luasnip";

        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = {
            modes = ["i" "s"];
            action = "cmp.mapping.select_next_item()";
          };
          "<S-Tab>" = {
            modes = ["i" "s"];
            action = "cmp.mapping.select_prev_item()";
          };
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };

        sources = [
          {name = "path";}
          #{name = "calc";}
          #{name = "nvim_lsp";}
          # {name = "cmp_tabnine";}
          #{name = "luasnip";}
          #{name = "buffer";}
          #{name = "neorg";}
        ];
      };   

      luasnip.enable = true;

      lsp = {
        enable = true;
        servers = {
          rnix-lsp.enable = true;
          pyright.enable = true;

        };
      };
      # Don't think I use this much.
      # Finds keybindings for commands you run.
      # I tend to look up the keybindings directly.
      # https://github.com/folke/which-key.nvim
      which-key = {
        enable = true;
      };


    };
    extraPlugins = [
      #Language highlighting
      pkgs.vimPlugins.indentLine
      pkgs.vimPlugins.vim-fish
      #pkgs.vimPlugins.vim-nix

      #Completion
      pkgs.vimPlugins.vim-repeat # Here to help with vim-surround
      pkgs.vimPlugins.nvim-ts-rainbow2 # Seems not to work right
      pkgs.vimPlugins.lexima-vim # Autocompleting parenthesis
      pkgs.vimPlugins.lsp_signature-nvim #type signature completion, like: fn(int,str)

      #Navigation
      pkgs.vimPlugins.vim-signature 
      pkgs.vimPlugins.ctrlp 
      #Syncronization
    ];

    keymaps = [
      # testing 
      { key = ",a";     action = ":echom('hello')<CR>";        mode = "n"; }
      # Magma
      { key = "_";      action = ":MagmaEvaluateLine<CR>";     mode = "n"; }
      { key = "<M-e>o"; action = ":MagmaEvaluateOperator<CR>"; mode = "n"; }
      { key = "<M-e>r"; action = ":MagmaEvaluateLine<CR>";     mode = "n"; }
      { key = "<M-e>c"; action = ":MagmaReevaluateCell<CR>";   mode = "n"; }
      { key = "<M-e>d"; action = ":MagmaDelete<CR>";           mode = "n"; }
      { key = "<M-e>O"; action = ":MagmaShowOutput<CR>";       mode = "n"; }
    ];

    /*
    extraConfigVim = ''
      let localleader = ","
      nnoremap ,a :echo("hello")<CR>

      nnoremap <expr><silent> <localleader>r  nvim_exec('MagmaEvaluateOperator', v:true)
      nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
      xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
      nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
      set number
    '';
    */

  };


  ##### VIM CONFIGS #####

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
  #programs.vim.defaultEditor = true;

  # don't think these do anything at the moment.
  #programs.neovim.vimAlias = false;
  #programs.neovim.viAlias  = false;

  }
