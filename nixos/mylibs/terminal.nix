{lib, pkgs, config, nix-unstable,  ...}:
with lib;
let
  secrets = (import ../secrets.nix {});
in
{
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

    # TUI file browser
    ranger

    # Network utilities
    nmap
    
  ];

  fonts.packages= with pkgs; [
    powerline-fonts
    meslo-lgs-nf
  ];

  documentation.dev.enable = true;
  programs.fish.enable = true;
  programs.nix-index.enable = true;
  programs.git = {
    enable = true;
    config = {  
      safe.directory = [ "/nix-sync" ];
      user.email = "13547477+volkswagenfeature@users.noreply.github.com";
      user.name = "volkswagenfeature";
      core.editor = "vim";
    };
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/nix-sync/nixos";
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
        theme = null;
      };
    };
  };
     
}
