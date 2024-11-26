/*
A graphical package set
Large apps, suites, and multifunctional enviroments.
*/
{pkgs,...}:
with pkgs;
[
  gimp-with-plugins
  blender
  kicad
  krita
  unityhub
  freecad-wayland

  # Libreoffice plus support packages
  libreoffice-qt
  hunspell
  hunspellDicts.en_US
]
