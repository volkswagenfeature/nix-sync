{lib, pkgs, config, ...}:
with lib;
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





  ];

  fonts.fonts = with pkgs; [
    powerline-fonts
    meslo-lgs-nf
  ];

  documentation.dev.enable = true;

  # Fish is configured with homemanager now
  /*
  programs.fish.enable = true;
  programs.fish.promptInit = ''
    any-nix-shell fish --info-right | source
  '';
  */

  # Of questionable neccesity? I'm leaving it commented out for now.
  # See https://nixos.wiki/wiki/Apropos  
  #documentation.man.generateCaches = true; 


}
