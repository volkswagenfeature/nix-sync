{config, pkgs, lib, ...}:
let
  secrets = ( import ../../../secrets.nix {} );
  wob-fifo = "/var/lib/misc/wob_fifo";
  bl-path = "/sys/class/backlight/amdgpu_bl10";

  # Does this work at all?
  brightness-script-monofile = stdenv.mkDerivation rec {
    name = "brightness-monofile";
    src = ./brightness.sh;
    nativeBuildInputs = [pkgs.awk];
    buildInputs = [pkgs.substituteAll];
    system = builtins.currentSystem;
    builder = builtins.writeScript "${name}-builder" ''
      substituteAll ${src} $out
    '';

    #Shell variables
    fifo_path = "${wob-fifo}";
    backlight_path = "${bl-path}";

  };
in
{
  environment.systemPackages = [pkgs.wob brightness-script-monofile] ;

  # Make it so brightness control doesn't require sudo
  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="${builtins.baseNameOf bl-path}", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w ${bl-path}/brightness"
'';
  # wob setup
  systemd.tmpfiles.rules = [
    "p ${wob-fifo}  666 root root - -"
  ];

  # Volume and brightness specific sway configs
  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    wayland.windowManager.sway = {
      /*
      startup = [
        {command = "tail -f ${wob-fifo} | wob";}
      ];
      # Fetched using wev
      keybindings= {
        "XF86MonBrightnessUp"   = "";
        "XF86MonBrightnessDown" = "";
        "XF86AudioRaiseVolume"  = "";
        "XF86AudioLowerVolume"  = "";
      };
      */
    };
  };
}
