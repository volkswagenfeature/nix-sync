/*
A graphical package set
Large apps, suites, and multifunctional enviroments.
*/
{pkgs, nix-razor,...}:
with pkgs;
{
  config.environment.systemPackages = with pkgs; [
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
    prusa-slicer
    printrun

    # Libreoffice plus support packages
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];
}
