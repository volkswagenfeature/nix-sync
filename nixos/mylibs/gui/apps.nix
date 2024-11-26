{lib,pkgs,config, nix-unstable, nixpkgs, ... }:
with lib;
let
  secrets = (import ../../secrets.nix {});
  freecad_overlay = (self: super: {
    freecad-wayland = super.freecad-wayland.overrideAttrs( prev:{
      version = "1.0.0";
    });
  });
in
{

  nixpkgs.overlays = [freecad_overlay];

  users.users."${secrets.primaryuser}".packages = with pkgs; [
    # Networking
    firefox
    chromium
    deluge
    tor-browser
    
    
    #ungoogled-chromium #for later


    # Design
    graphviz
    #nix-unstable.super-slicer #(Broken as of 2024-06-09)

    # Utilities
    kitty
    obsidian
    vlc
    # TODO: write function to autodetect the version of electron obsidian wants
    # and allow it even if it's insecure.

    #Gaem
    prismlauncher
    steam


    # image processing
    imagemagick
    feh

    # Password managment
    keepassxc

    # Office
    #libreoffice-qt
    #hunspell
    #hunspellDicts.en_US
    webcord-vencord
  ] ++ (import ../packsets/app-suites.nix pkgs)
    ++ (import ../packsets/social-media.nix pkgs);
    

  fonts.packages= with pkgs; [
    noto-fonts
    minecraftia
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


