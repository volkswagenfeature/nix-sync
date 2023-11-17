{ config, pkgs, lib, ... }:
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


in
{
  environment.systemPackages = with pkgs; [
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for openning default programms when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme  # default gnome cursors
    swaylock
    swayidle
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer

    # Brightness utilities
    gammastep
    light

    # Displays a overlay bar
    wob
  ];

  services.xserver = {
    enable = true;
    
    /*
    displayManager.ly = {
      enable = true;
      defaultUser = "${secrets.primaryuser}";
    }; */
  };


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Make it so changing my brightness doesn't require sudo
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/intel_backlight/brightness"
  '';

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
  # Enabled by homemanager, so should not be needed
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #};


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
        modifier = "Mod4";
        startup [
          {command = "tail -f /var/lib/misc/wob_fifo | wob";}
        ]
      }; 
    };
    # Gammastep conifgs ( seems to work? )
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 6500;
        night = 3000;
      };
    };
  };

  # wob setup
  systemd.tmpfiles.rules = [
    "p /var/lib/misc/wob_fifo  666 root root - -"
  ];





  #services.udev.extraHwdb = ''
  #  evdev:input:b0003v0B05p17BE*
  #  '';

}
