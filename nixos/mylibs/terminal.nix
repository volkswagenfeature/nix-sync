{lib, pkgs, config, ...}:
with lib;
{
  environment.systemPackages = with pkgs; [
    oh-my-fish
    tree
    git
    
    # man pages packages
    manpages
    man-db
    man-pages
    man-pages-posix

    # Shell assist
    nix-index





  ];

  documentation.dev.enable = true;
  # Of questionable neccesity? I'm leaving it commented out for now.
  # See https://nixos.wiki/wiki/Apropos  
  #documentation.man.generateCaches = true; 


}
