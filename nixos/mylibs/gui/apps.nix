{
  lib,
  pkgs,
  config, 
  nix-unstable, 
  nixpkgs, 
  nix-razor, 
  inputs, 
  extra-args,
  ...
}:
with lib;
let
  secrets = (import ../../secrets.nix {});
  system = inputs.defaults.system;
  /*
  ss14_overlay = (self: super: {
    space-station-14-launcher = super.space-station-14-launcher.overrideAttrs(
      prev:{
        version = "0.30.2";
        src = pkgs.fetchFromGitHub {
          owner = "space-wizards";
          repo = "SS14.Launcher";
          rev = "v0.30.2";
          hash = "sha256-Rx39FuDPh5sGVjcKjCo4mTQ8Z/x9PD1CvBQh5ICES9Q=";
          fetchSubmodules = true;
        };
      }
    );
    });
    */
in
{
  imports = [
    ../packsets/app-suites.nix 
    ../packsets/social-media.nix
  ];

  nixpkgs.overlays = [
    #freecad_overlay
    #ss14_overlay
  ];

  users.users."${secrets.primaryuser}".packages = with pkgs; [
    # Networking
    chromium
    deluge
    tor-browser
    
    
    #ungoogled-chromium #for later


    # Design
    graphviz
    #nix-unstable.super-slicer #(Broken as of 2024-06-09)

    # Utilities
    kitty
    nix-razor.obsidian
    vlc
    # TODO: write function to autodetect the version of electron obsidian wants
    # and allow it even if it's insecure.

    #Gaem
    prismlauncher
    steam
    space-station-14-launcher


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
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
  };

  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{ };

}


