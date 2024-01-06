{lib,pkgs,config, nix-unstable,... }:
with lib;
let
  secrets = (import ../../secrets.nix {});
in
{
  users.users."${secrets.primaryuser}".packages = with pkgs; [
    # Networking
    firefox
    chromium
    
    #ungoogled-chromium #for later

    # Social media
    discord
    element-desktop

    # Design
    graphviz
    super-slicer
    gimp-with-plugins
    blender
    krita

    # Utilities
    kitty
    nix-unstable.obsidian
    #obsidian

    # image processing
    imagemagick
    feh

    # Password managment
    keepassxc

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
  ];

  fonts.packages= with pkgs; [
    noto-fonts
    #noto-fonts-extra
  ];


  environment.systemPackages = with pkgs; [
	  kitty
	  feh
	 ];
  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{ };
}


