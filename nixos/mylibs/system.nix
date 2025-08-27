{lib, pkgs, config, inputs, nix-unstable, ... }:
with lib;
let
  secrets = (import ../secrets.nix {});
in
{
  imports = [
    ./packsets/cloud-engineering.nix
    ./packsets/inspection-tools.nix
  ];
  environment.systemPackages = with pkgs; [
     # System core components
     uutils-coreutils

     # Runtime packages
     python3Full
     poetry

     # Clipboard utility
     wl-clipboard-x11

     # password management
     kpcli
     gnupg

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
  # Nix config modifications
  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];


  # Symlink nix-sync directory
  # systemd.tmpfiles.rules = ["L /nix-sync/nixos - - - - /etc/nixos"];

  # Enable polkit ( required for sway and homemanager )
  security.polkit.enable = true;

  # ssh-agent config
  programs.ssh.startAgent = true;

  ### Networking ###
  networking.hostName = "${secrets.hostname}"; # Define your hostname.

  # Disable networking service to improve boot performance
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [];

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  programs.dconf.enable = true; # May be needed by blueman-manager to work.
  #hardware.bluetooth.powerOnBoot = true;


  ### Internationilization/Input ###
  # Set your time zone.
  # Should be handled by timed, so has to be unset.
  #time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Setup home-manager global options
  home-manager = {  
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  ### User configs ###


  #For UID and GID range specing
  users.users.root = {
    uid = 0;
    subGidRanges = lib.mkForce [
      {
        count = 99990;
        startGid = 100000;
      }
    ];
    subUidRanges = lib.mkForce [
      {
        count = 99990;
        startUid = 100000;
      }
    ];
  };

  users.users."${secrets.primaryuser}"= {
    isNormalUser = true;
    description = "${secrets.primaryuser}";
    extraGroups = [ "networkmanager" "wheel" "lxd" "incus" "docker"];
    packages = with pkgs; [
      # GUI apps should be moved to ./gui/apps.nix

      # Hardware utils. 
      # I should be the only user to mess with hardware...
      minicom
      usbutils
    ];
    shell = pkgs.fish;
    uid = 1000;
    subGidRanges = [
      {
        count = 99990;
        startGid = 200000;
      }
    ];
    subUidRanges = [
      {
        count = 99990;
        startUid = 200000;
      }
    ];
  };
  #enviroment.shells = [pkgs.fish];


  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    programs.keychain = {
      enable = true;
      enableFishIntegration = true;
      keys = map toString secrets.ssh_keys.paths;

    };
  };

  ### Services ###
  services = {
    # Create a compatible filesystem for scripts with shebangs
    envfs.enable = true; 
    # Enable cups
    printing.enable = true;
    # Enable bluetooth service
    blueman.enable = true;
    # Sync your system clock when you travel
    localtimed.enable = true;
    # Something to do with geopositioning?
    avahi.enable = true;
    geoclue2 = {
      enable = true;
      # switching to google because mozilla can't provide a fix for some reason.
      geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyBQLrZNtaQz3KgXw2O0dDUFIxyscxpujNQ";

      appConfig = {
        gammastep = {isAllowed = true; isSystem = true;};
        where-am-i = {isAllowed = true; isSystem = false;};
      };
    };
    # Audio configs
    pipewire = {
       enable = true;
       alsa.enable = true;
       alsa.support32Bit = true;
       pulse.enable = true;
       # If you want to use JACK applications, uncomment this
       #jack.enable = true;
       # use the example session manager (no others are packaged yet so this is enabled by default,
       # no need to redefine it in your config for now)
       #media-session.enable = true;
      };
    # hardware updates
    # Allow firmware updates through a daemon
    # Disabled as it adds significant time to boot.
    # It would be clever to write a task to only boot with this when needed.
    # There is also a manual option: fwupdtool, 
    # that might pair well with a nix hardware
    # management tool of some sort.
    fwupd.enable = true;
  };


  ### Audio ###
  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
}
