{lib, pkgs, config, inputs, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
    # System core components
    toybox
    cryptsetup
    btrfs-progs

    # Runtime packages
    python39Full

    # Monitoring 
    htop
    neofetch

    # Clipboard utility
    xclip

    # cloud syncronization
    rclone
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

  # Setup home-manager global options
  home-manager = {  
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  ### User configs ###

  users.users.tristan = {
    isNormalUser = true;
    description = "tristan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # GUI apps should be moved to ./gui/apps.nix

      # Hardware utils. 
      # I should be the only user to mess with hardware...
      minicom
      usbutils


    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles = [
      "/home/tristan/.ssh/github_ed25519"
    ];
  };
  #enviroment.shells = [pkgs.fish];
  

  # Homemanager configs
  home-manager.users.tristan = {pkgs, ...}:{
    #programs.ohmyfish.enable = true;
    home.stateVersion = "22.11";

  };

  #Alternate test user
  users.users.test = {
    isNormalUser = true;
    description = "testUser";
    password = "";
    extraGroups = [];
  };

}
