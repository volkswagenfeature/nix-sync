{lib, pkgs, config, inputs, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
    toybox
    python39Full
    htop
    neofetch

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
      super-slicer
      discord
      graphviz
      imagemagick

      # Hardware utils. 
      # I should be the only user to mess with hardware...
      minicom
      usbutils

    ];
    openssh.authorizedKeys.keyFiles = [
      "/home/tristan/.ssh/github_ed25519"
    ];
  };

  # Homemanager configs
  home-manager.users.tristan = {pkgs, ...}:{
    programs.fish.enable = true;
  };

  #Alternate test user
  users.users.test = {
    isNormalUser = true;
    description = "testUser";
    password = "";
    extraGroups = [];
  };

}
