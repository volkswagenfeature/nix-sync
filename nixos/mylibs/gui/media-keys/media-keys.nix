{config, pkgs, lib, stdenv, ...}:
let
  secrets  = (import ../../../secrets.nix {});

  # Path variables
  wobfifo = "/var/lib/misc/wob_fifo";
  blpath = "/sys/class/backlight/amdgpu_bl0";

  # Others
  steps = 9;
  blmax = 255;

  ### Package definitions ###

  brightness = pkgs.stdenv.mkDerivation rec {
      name = "brightness";
      inherit wobfifo blpath steps blmax;

      src = ./.;

      configurePhase= ''
        mkdir -p $out/bin
        cp -t $out/bin/ ./brightness.sh 
        chmod +x $out/bin/brightness.sh
        
        SPECIAL=$( ./generator.sh )
        substituteInPlace $out/bin/brightness.sh \
          --replace "wob-fifo"  "$wobfifo"\
          --replace bl-path   "$blpath"\
          --replace val-array "$SPECIAL"
      '';
    };  

  vol-control = pkgs.writeShellScriptBin "vol-control" ''
    eval "${pkgs.pamixer}/bin/pamixer -$1 10"
    if [[ $(${pkgs.pamixer}/bin/pamixer --get-mute) = "true" ]] &&\
       [[ $(${pkgs.pamixer}/bin/pamixer --get-volume) -ne 0 ]] 
    then
      echo $(($(${pkgs.pamixer}/bin/pamixer --get-volume)+199)) > ${wobfifo}

    else
      ${pkgs.pamixer}/bin/pamixer --get-volume > ${wobfifo}
    fi
  '';
in
{

  environment.systemPackages = [pkgs.wob brightness vol-control];

  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/amdgpu_bl0/brightness"
'';

  # wob setup
  systemd.tmpfiles.rules = [
    "p ${wobfifo}  666 root root - -"
  ];

  # Volume and brightness specific sway configs
  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    wayland.windowManager.sway.config = {
      
      startup = [
        {command = "tail -f ${wobfifo} | wob";}
      ];
      # setting this currently causes all other sway shortcuts to be disabled,
      # breaking my DE
      
      keybindings = lib.mkOptionDefault {
        "XF86MonBrightnessUp"   = "exec ${brightness}/bin/brightness.sh 1";
        "XF86MonBrightnessDown" = "exec ${brightness}/bin/brightness.sh -1";
        "XF86AudioRaiseVolume" = "exec ${vol-control}/bin/vol-control i";
        "XF86AudioLowerVolume" = "exec ${vol-control}/bin/vol-control d";
        "XF86AudioMute"        = "exec ${vol-control}/bin/vol-control t";
      } ;
    };
  };
}

