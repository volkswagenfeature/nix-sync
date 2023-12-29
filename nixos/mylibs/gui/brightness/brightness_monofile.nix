{config, pkgs, lib, ...}:
let
  secrets = ( import ../../../secrets.nix {} );
  wob-fifo = "/var/lib/misc/wob_fifo";
  bl-path = "/sys/class/backlight/amdgpu_bl0";

  brightness-script = pkgs.writeShellScriptBin "brightness" ''
  FIFO_PATH="${wob-fifo}"
  #"/var/lib/misc/wob_fifo"
  BACKLIGHT_PATH="${bl-path}"
  #"/sys/class/backlight/amdgpu_bl0"
  MIN_BRIGHTNESS=0
  MAX_BRIGHTNESS=$( cat $BACKLIGHT_PATH/max_brightness )
  CUR_BRIGHTNESS=$(cat $BACKLIGHT_PATH/brightness)

  TARGET_BRIGHTNESS="$((CUR_BRIGHTNESS - MIN_BRIGHTNESS))"

  INCREMENT_BY=$1

  SCALE_FACTOR=1.5

  echo "MAX=$MAX_BRIGHTNESS MIN=$MIN_BRIGHTNESS CUR=$CUR_BRIGHTNESS"


  if [[ $INCREMENT_BY -gt 0 ]]
  then
    #  $TARGET_BRIGHTNESS+1 ensures it never hits zero and gets stuck.
    RES=$( awk -v s="$((TARGET_BRIGHTNESS+1))"\
               -v e="$SCALE_FACTOR"\
               -v i="$INCREMENT_BY"\
    'BEGIN {for (;i > 0; i--) s *= e; printf "%.f", s}'\
    )
    echo "RES=$RES"

    if [[ $RES -gt $((MAX_BRIGHTNESS-MIN_BRIGHTNESS)) ]]
    then
      RES=$((MAX_BRIGHTNESS-MIN_BRIGHTNESS))
    fi
        
  elif [[ $INCREMENT_BY -lt 0 ]]  
  then
    RES=$( awk -v s="$((TARGET_BRIGHTNESS+1))"\
               -v e="$SCALE_FACTOR"\
               -v i="$(($INCREMENT_BY*-1))"\
    'BEGIN {for (;i > 0; i--) s /= e; printf "%.f\n", s}'\
    )
    echo "RES=$RES"

    if [[  $RES -lt 0  ]]
    then
      RES=0
    fi
  fi
    RES=$((RES + MIN_BRIGHTNESS))


    echo $RES > $BACKLIGHT_PATH/brightness


    # Log scale display
    echo "WRITING:"
    awk -v hi="$((MAX_BRIGHTNESS-MIN_BRIGHTNESS))"\
        -v r="$((RES-MIN_BRIGHTNESS))"\
        -v s="$SCALE_FACTOR"\
        -v i="$RES"\
    'BEGIN {m_hi=log(hi)/log(s); m_i=log(i)/log(s); ratio=m_i/m_hi*100; printf "%.f\n", ratio }'\
    > $FIFO_PATH

  # debug print
  '';
in
{
  environment.systemPackages = [pkgs.wob brightness-script] ;

  # Make it so brightness control doesn't require sudo
  /*
  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="${builtins.baseNameOf bl-path}", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w ${bl-path}/brightness"
'';
  */
  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/amdgpu_bl0/brightness"
'';



  # wob setup
  systemd.tmpfiles.rules = [
    "p ${wob-fifo}  666 root root - -"
  ];

  # Volume and brightness specific sway configs
  home-manager.users."${secrets.primaryuser}"= {pkgs, ...}:{
    wayland.windowManager.sway.config = {
      
      startup = [
        {command = "tail -f ${wob-fifo} | wob";}
      ];
      # setting this currently causes all other sway shortcuts to be disabled,
      # breaking my DE
      /*
      keybindings= {
        "XF86MonBrightnessUp"   = "${brightness-script} 1";
        "XF86MonBrightnessDown" = "${brightness-script} -1";
        "XF86AudioRaiseVolume"  = "true";
        "XF86AudioLowerVolume"  = "true";
      };
      */
      
    };
  };
}
