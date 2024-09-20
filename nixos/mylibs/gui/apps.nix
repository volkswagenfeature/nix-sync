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
    deluge
    tor-browser
    
    
    #ungoogled-chromium #for later

    # Social media
    nix-unstable.discord
    element-desktop
    telegram-desktop
    signal-desktop
    whatsapp-for-linux
    zulip
    zulip-term
    slack

    # Design
    graphviz
    #nix-unstable.super-slicer #(Broken as of 2024-06-09)
    gimp-with-plugins
    blender
    krita
    nix-unstable.freecad
    unityhub
    kicad

    # Utilities
    kitty
    nix-unstable.obsidian
    vlc
    # TODO: write function to autodetect the version of electron obsidian wants
    # and allow it even if it's insecure.

    #Gaem
    prismlauncher


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
  ];

  fonts.packages= with pkgs; [
    noto-fonts
    minecraftia
    #noto-fonts-extra
  ];

  environment.systemPackages = with pkgs; [
    kitty
    feh
  ];


  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{ };
}


