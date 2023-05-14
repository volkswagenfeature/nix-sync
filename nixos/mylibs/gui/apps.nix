{lib,pkgs,config, ... }:
with lib;
let
  secrets = (import ../../secrets.nix {});
in
{
  users.users."${secrets.primaryuser}".packages = with pkgs; [
    # Networking
    firefox

    # Social media
    discord
    element-desktop

    # Design
    graphviz
    super-slicer

    # Utilities
    kitty
    obsidian

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

  fonts.fonts = with pkgs; [
    noto-fonts
    #noto-fonts-extra
  ];


  environment.systemPackages = with pkgs; [
	  kitty
	  feh
	 ];
  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{
    config.programs.kitty  = {
      # Themes at https://github.com/kovidgoyal/kitty-themes
      theme = "ayu";
    };
  };
}


