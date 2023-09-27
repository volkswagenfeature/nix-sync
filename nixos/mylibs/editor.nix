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
      number = true;

      # Disabled in neovim, on by default
      #ruler  = true;
      #hlsearch = true;
      #syntax = true;
      # nocompatible = true;

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
    };
    extraPlugins = [
      #Language highlighting
      pkgs.vimPlugins.indentLine
      pkgs.vimPlugins.rainbow 
      pkgs.vimPlugins.vim-fish
      #pkgs.vimPlugins.vim-nix

      #Completion
      pkgs.vimPlugins.vim-repeat 
      # pkgs.vimPlugins.vim-surround 
      pkgs.vimPlugins.lexima-vim
      pkgs.vimPlugins.which-key-nvim
      pkgs.vimPlugins.lsp_signature-nvim

      #Navigation
      pkgs.vimPlugins.vim-signature 
      pkgs.vimPlugins.ctrlp 
      pkgs.vimPlugins.nerdtree
      #Syncronization
    ];
    maps = {
      # Magma
      normal.",a" = {
        action = ":echom('hello')<CR>";
      };
      normal."_".action = ":MagmaEvaluateLine<CR>";
      /*
      normal = {  
        "<M-e>o".action  = ":MagmaEvaluateOperator<CR>";
        "<M-e>r".action = ":MagmaEvaluateLine<CR>";
        "<M-e>c".action = ":MagmaReevaluateCell<CR>";
        "<M-e>d".action = ":MagmaDelete<CR>";
        "<M-e>O".action = ":MagmaShowOutput<CR>";
      };
      */

    };

    extraConfigVim = ''
      let localleader = ","
      nnoremap ,a :echo("hello")<CR>

      nnoremap <expr><silent> <localleader>r  nvim_exec('MagmaEvaluateOperator', v:true)
      nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
      xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
      nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
      set number
    '';

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
