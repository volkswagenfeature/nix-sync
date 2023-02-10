{lib, pkgs, config, inputs, ... }:
with lib;
let
  secrets = (import ../secrets.nix {});
in
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

    # password management
    kpcli

    # secrets managment
    keychain
  ];

  # Enable polkit ( required for sway and homemanager )
  security.polkit.enable = true;

  # ssh-agent config
  programs.ssh.startAgent = true;

  ### Networking ##
  networking.hostName = "${secrets.hostname}"; # Define your hostname.

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

  users.users."${secrets.primaryuser}"= {
    isNormalUser = true;
    description = "${secrets.primaryuser}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # GUI apps should be moved to ./gui/apps.nix

      # Hardware utils. 
      # I should be the only user to mess with hardware...
      minicom
      usbutils


    ];
    shell = pkgs.fish;
  };
  #enviroment.shells = [pkgs.fish];

  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    programs.keychain = {
      enable = true;
      enableFishIntegration = true;
      keys = map toString secrets.ssh_keys.paths;

    };
  };
}
