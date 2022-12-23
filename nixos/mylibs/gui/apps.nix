{lib,pkgs,config, ... }:
with lib;
{
  users.users.tristan.packages = with pkgs; [
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
  ];

  environment.systemPackages = with pkgs; [
	  kitty
	  feh
	 ];
}


