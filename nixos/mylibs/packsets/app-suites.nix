/*
A graphical package set
Large apps, suites, and multifunctional enviroments.
*/
{pkgs, nix-razor,...}:
with pkgs;
let
  # This needs to be added to nixpkgs. The package is broken
  # and missing this dep.
  printrun_over = ( self: super:{ 
    printrun = super.printrun.overridePythonAttrs (
      prev:{
        dependencies = [
          pkgs.python312Packages.platformdirs
        ];
      }
    );
  });
  
in
{
  config.nixpkgs.overlays = [ printrun_over ];

  config.environment.systemPackages = with pkgs; [
    # Video and animation
    blender
    #nix-razor.unityhub
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

    # vscode
    (
      vscode-with-extensions.override {
        vscode = vscodium.override {
          commandLineArgs = "--password-store='gnome-libsecret'";
        };
        vscodeExtensions = callPackage ./codium-plugins.nix {};
      }
    )

    # Android
    android-tools
    android-studio-tools
    #android-studio-full
    android-udev-rules
  ];
}
