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
    conda
    micromamba
  ];
  # Nix config modifications
  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];



  # Symlink nix-sync directory
  # systemd.tmpfiles.rules = ["L /nix-sync/nixos - - - - /etc/nixos"];

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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Enable bluetooth.
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  #hardware.bluetooth.powerOnBoot = true;

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




  ### Services ###


  services.avahi.enable = true;
  #services.geoclue-agent.enable = true; # does not exist

  services.geoclue2 = {
    enable = true;
    # switching to google because mozilla can't provide a fix for some reason.
    geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyBQLrZNtaQz3KgXw2O0dDUFIxyscxpujNQ";

    appConfig = {
      gammastep = {isAllowed = true; isSystem = true;};
      where-am-i = {isAllowed = true; isSystem = false;};
    };
  };

   
  services.tailscale.enable = true;

  ### Audio ###
  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
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


}
