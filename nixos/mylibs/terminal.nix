{lib, pkgs, config, ...}:
with lib;
let
  secrets = (import ../secrets.nix {});
in
{
  environment.systemPackages = with pkgs; [
    oh-my-fish
    fish
    tree
    git
    
    # man pages packages
    man-db
    man-pages
    man-pages-posix

    # Shell assist
    nix-index
    any-nix-shell

    # preview fonts
    fontpreview

    # big terminal font
    figlet

    # TUI file browser
    ranger
  ];

  fonts.fonts = with pkgs; [
    powerline-fonts
    meslo-lgs-nf
  ];

  documentation.dev.enable = true;

  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    programs.fish = { 
      enable = true;
      plugins = [
        {
          name = "tide-theme";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "0cf2993d37e317a405114b78df6a5440eeb88bbb";
            sha256 = "x0wwXjKCDwtoUUJaiixeRRt5J6+EFD4Qev6kuOhd9Zw=";
          };
        } 
        /*
        {
        name = "theme-chain";
        src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-chain";
        rev = "1cffea20b15bbcd11e578cd88dca097cc2ca23f4";
        sha256 = "x0wwXjKCDwtoUUJaiixeRRt5J6+EFD4Qev6kuOhd9Zw=";
        };
        }
        */
      ];
      functions = { 
        screenshot = ''grim -g "$(slurp)" '';
        fullscreenshot = ''grim'';
        icat = ''kitty +kitten icat $argv'';
      };
    }; 
    /*
    programs.ranger = 
    {  
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };
    */
    home.stateVersion = "22.11";
  };
     
}
