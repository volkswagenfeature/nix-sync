{lib, pkgs, config, inputs, nix-unstable, ... }:
with lib;
let
  secrets = (import ../secrets.nix {});
in
{
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  environment.systemPackages = with pkgs; [
    # System core components
    toybox
    cryptsetup
    btrfs-progs

    # Runtime packages
    python39Full
    # poetry

    # Monitoring 
    htop
    neofetch
    nix-tree #Explore the package tree

    pv

    # Clipboard utility
    wl-clipboard-x11

    # cloud syncronization
    # Switched back to 23.11...
    rclone

    # password management
    kpcli

    # secrets managment
    keychain

    # Zipfile handling
    zip
    unzip

    # Geolocation framework (only used by gammastep atm)
    geoclue2-with-demo-agent # Same thing as the override???
    #geoclue2#.override {withDemoAgent = config.services.geoclue2.enableDemoAgent;}
    avahi
  ];
  # Create a compatible filesystem for scripts with shebangs
  services.envfs.enable = true;

  # Enable polkit ( required for sway and homemanager )
  security.polkit.enable = true;

  # ssh-agent config
  programs.ssh.startAgent = true;

  ### Networking ##
  networking.hostName = "${secrets.hostname}"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Disable networking service to improve boot performance
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [];


  # Enable network manager applet
  programs.nm-applet.enable = true;

  ### Internationilization/Input ###
  # Set your time zone.
  time.timeZone = "America/New_York";
  # Keep timezone up to date based on current location. 
  # Gonna want to confirm this works next time you're somewhere fancy.
  services.localtimed.enable = true;

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

  /*
  # Eventually should replace manual config + service declearation below
  # but doesn't work yet.
  services.restic.backups."${secrets.primaryuser}" = {
    passwordFile =  "/home/${secrets.primaryuser}/.config/rclone/rclone.conf";
    rcloneConfigFile = /. + "/home/${secrets.primaryuser}/.config/rclone/rclone.conf";

    
    rcloneConfig = {
      #type = "dropbox";
      token = traceVal (builtins.toJSON ( secrets.rclone.dropbox ));

    };
   
  };
  */
 
  /*
  systemd.timers."rclone-test" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      onBootSec = "5m";
      onUnitActiveSec = "2m";
      Unit = "rclone-test.service";
    };
  };
  */

  systemd.services."rclone-test" = {
    script = ''
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "nobody";
    };
  };
  services.avahi.enable = true;
  #services.geoclue-agent.enable = true; # does not exist

  services.geoclue2 = {
    enable = true;

    appConfig = {
      gammastep = {isAllowed = true; isSystem = true;};
      where-am-i = {isAllowed = true; isSystem = false;};
    };
  };

   
  services.tailscale.enable = true;

}
