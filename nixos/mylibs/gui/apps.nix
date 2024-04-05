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
    telegram-desktop
    signal-desktop
    whatsapp-for-linux

    # Design
    graphviz
    super-slicer
    gimp-with-plugins
    blender
    krita

    # Utilities
    kitty
    nix-unstable.obsidian
    # TODO: write function to autodetect the version of electron obsidian wants
    # and allow it even if it's insecure.

    # image processing
    imagemagick
    feh

    # Password managment
    keepassxc

    # Office
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    webcord-vencord

    #gaems
    steam
  ];

  fonts.packages= with pkgs; [
    noto-fonts
    #noto-fonts-extra
  ];

  environment.systemPackages = with pkgs; [
    kitty
    feh
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
  };


  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{ };
}


