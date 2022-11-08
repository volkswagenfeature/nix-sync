{lib, pkgs, config, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
    home-manager

  ];

  # ssh-agent config
  programs.ssh.startAgent = true;

  ### Networking ##
  networking.hostName = "BetaBlue-NixOS-2022"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  ### Internationilization/Input ###
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  ### User configs ###

  users.users.tristan = {
    isNormalUser = true;
    description = "tristan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Homemanager configs
  # users.users.nixos.isNormalUser = true;
  # home-manager.users.nixos = {pkgs, ...}:{
  #  programs.fish.enable = true;
  # };






}
