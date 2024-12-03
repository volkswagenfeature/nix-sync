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
  [
    gimp-with-plugins
    nix-razor.blender
    kicad
    krita
    nix-razor.unityhub
    nix-razor.freecad-wayland
    meshlab

    # Libreoffice plus support packages
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ]
