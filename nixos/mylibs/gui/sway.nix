{ config, pkgs, lib, nix-unstable, ... }:
# Straight copied from https://nixos.wiki/wiki/Sway


let
  # Secrets
  secrets = ( import ../../secrets.nix {} );

  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
  dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
  systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
  systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
  };

  wallPath = /bulk + "/${secrets.primaryuser}-dropbox" + /Photos/Backgrounds;
  swap-delay = "10m";
  backgroundScript = pkgs.writeShellApplication {
    name = "backgroundScript";
    runtimeInputs = [pkgs.swaybg pkgs.findutils pkgs.imagemagick];
    text = ''
      while true; do
        find ${wallPath} -type f \
          -exec magick identify {} \;\
          -exec swaybg --image {} --mode fill \;\
          -exec sleep ${swap-delay} \;
      done
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
        '';
  };

  
  #TUIgreet script and values
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  swaystart= "${pkgs.sway}/bin/sway";
  swaydebug= "${swaystart} -d > /home/${secrets.primaryuser}/swaylog3 2>&1";



in
{
  imports = [
    ./media-keys/media-keys.nix
    #./brightness/brightness.nix
  ];
  environment.systemPackages = with pkgs; [
    # Local scripts
    dbus-sway-environment
    configure-gtk
    backgroundScript

    # nixpkgs
    sway
    wayland
    xdg-utils # for openning default programms when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    swaybg
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer

    # Brightness utilities
    gammastep
    light

  ];

  ## Display manager
  services.greetd = {
    enable = true;
    package = pkgs.greetd.tuigreet;
    settings = {
      default_session = {
        command = "${tuigreet} --time --remember --cmd '${swaystart}'";
      };
    };
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  # Enabled by homemanager, but commenting this out causes breakage. 

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };


  ### HomeManager section
  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        terminal = "kitty";
        input."type:touchpad" = {
          # Docs: https://man.archlinux.org/man/sway-input.5
          click_method = "clickfinger";
          middle_emulation = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };

        input."2821:6078:ASUS_Computer_Inc._ASUS_GAMING_MOUSE_GX950" = { # Config for mouse has to be fixed before going to do art.
          pointer_accel = "-0.5"; # seems to do nothing
        };
        output."eDP-1" = {
          scale = "1.5";
          #bg = "/home/${secrets.primaryuser}/Straight-flat-inconsolata3.png center";
        };
        modifier = "Mod4";
      startup = [{command = "${backgroundScript}/bin/backgroundScript";}];
      #keybindings = {"XF86MonBrightnessUp"="echo testval";};
      }; 

    };
    # Gammastep conifgs 
    services.gammastep = {
      enable = true;
      provider = "geoclue2";

      # If location breaks again, swap this in.
      /*
      provider = "manual";
      latitude = 38.8;
      longitude = -77.04;
      */

      temperature = {
        day = 6500;
        night = 3000;
      };
    };
  };

  #services.udev.extraHwdb = ''
  #  evdev:input:b0003v0B05p17BE*
  #  '';

}
