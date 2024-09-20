{lib, pkgs, config, inputs, nix-unstable, ... }:
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
    pciutils # The lspci that comes with toybox sucks ass
    inotify-tools # for filewatching 

    # Runtime packages
    python3Full
    poetry

    # Monitoring 
    htop
    neofetch
    nix-tree #Explore the package tree
    pv

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

    # Bluetooth
    bluez

    # Audio
    pamixer

    # Virtual Enviroments
    # Might not even work. Plus I have poetry2nix.
    #conda
    #micromamba
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

  ### Networking ##
  networking.hostName = "${secrets.hostname}"; # Define your hostname.
  networking.hosts = { "127.0.0.1" = ["yodayo.com" "civitai.com"]; };

  # Enable networking
  networking.networkmanager.enable = true;

  # Disable networking service to improve boot performance
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [];

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  #hardware.bluetooth.powerOnBoot = true;


  ### Internationilization/Input ###
  # Set your time zone.
  time.timeZone = "America/New_York";
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
    # Tailscale VPN
    tailscale.enable = true;
    # hardware updates
    fwupd.enable = true;
  };


  ### Audio ###
  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
}
