/*
A graphical package set
Large apps, suites, and multifunctional enviroments.
*/
{pkgs, nix-razor,...}:
with pkgs;
  /*
  overlayed = pkgs.lib.mkPackages {
    nixpkgs = pkgs;
    overlays = [nix-unstable nix-razor];
  };
  */
  # The idea the overlays represent is automatic failover: if I can't find a 
  # package in one, I fall back until I do.
  # Several issues that are unsolved:
  # - However I compute this, I need to make sure that every invocation isn't
  #   re-overlaying nixpkgs. While probably "tolerable", it would still eat ram
  #   and compute time.
  # - I'm also not sure it's nesicary. The only reason to do this is so if 
  #   I continue with the artifact idea, and don't have pkgs, unstable, and razor
  #   set up on every artifact, I don't have to mess with these files. 
  [
    # Video and animation
    nix-razor.blender
    nix-razor.unityhub
    obs-studio

    # Images
    krita
    gimp-with-plugins

    # Engineering
    kicad
    #nix-razor.freecad-wayland
    freecad-wayland
    meshlab

    # Libreoffice plus support packages
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ]
