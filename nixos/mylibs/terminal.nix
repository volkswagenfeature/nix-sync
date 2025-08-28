{lib, pkgs, config, ...}:
with lib;
let
  secrets = (import ../secrets.nix {});
in {
  environment.systemPackages = with pkgs; [
    oh-my-fish
    fish
    tree

    # git + Github CLI
    git
    gh
    
    # man pages packages
    man-db
    man-pages
    man-pages-posix

    # Shell assist
    # nix-index # Replaced by flake nix-index-database
    any-nix-shell
    nix-output-monitor

    # preview fonts
    fontpreview

    # big terminal font
    figlet

    # TUI file browsers
    ranger
    nnn

    # Network utilities
    nmap

    # neovim as pager
    nvimpager
    
  ];

  fonts.packages= with pkgs; [
    powerline-fonts
    meslo-lgs-nf
  ];

  # Needs font translation
  #console.font = "${pkgs.powerline-fonts}/share/fonts/truetype/Meslo LG S DZ Regular for Powerline.ttf";
  fonts.fontDir.enable = true;

  documentation.dev.enable = true;
  programs= {
    fish.enable = true;
    nix-index.enable = true;
    git = {
      enable = true;
      config = {  
        safe.directory = [ "/nix-sync" ];
        user.email = "13547477+volkswagenfeature@users.noreply.github.com";
        user.name = "volkswagenfeature";
        core.editor = "vim";
      };
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 7";
      flake = "/nix-sync/nixos";
    };
    direnv.enableFishIntegration = true;
  };

  services = {
    lorri.enable = true;

  };


  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    programs = {  
      fish = { 
        enable = true;
        functions = { 
          screenshot = ''grim -g "$(slurp)" '';
          fullscreenshot = ''grim'';
          icat = ''kitty +kitten icat $argv'';
          ssh = ''kitty +kitten ssh $argv'';
        };
        shellInit = strings.concatStringsSep "\n" [
          "set -gx EDITOR vim"
          "set -gx PAGER  nvimpager"
        ];
      }; 
      
      
      # No homemanager module for ranger. Maybe you should write one?
      ranger = {  
        enable = true;
        settings = {
          preview_images = true;
          preview_images_method = "kitty";
        };


      };
      
     
      kitty = {
        enable = true;
        settings = {
          confirm_os_window_close = 0;
        };
      };
    };
  };
     
}
