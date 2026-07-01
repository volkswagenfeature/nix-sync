/*
A graphical package set
Large apps, suites, and multifunctional enviroments.
*/
{pkgs, nix-razor, nix-unstable, ...}:
{
  config.environment.systemPackages = with pkgs; [
    # Video and animation
    blender
    #nix-razor.unityhub
    obs-studio

    # Images
    krita
    gimp-with-plugins
    libwacom
    libwacom-surface


    # Libreoffice plus support packages
    hunspell
    hunspellDicts.en_US
    libreoffice

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
  ];
}
