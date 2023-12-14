{config, pkgs, lib, ...}:
let
  secrets = ( import ../../secrets.nix {} );
  wob-fifo = /var/lib/misc/wob_fifo;
  bl-path = /sys/class/backlight/amdgpu_bl10;

  brigthtness-script = pkgs.writeShellScript "brightness-script"
  ''
  BACKLIGHT_PATH="${bl-path}"
  MIN_BRIGHTNESS=0
  MAX_BRIGHTNESS=$( cat ${bl-path}/max_brightness )
  CUR_BRIGHNESS=$(cat ${bl-path}/brightness)

  TARGET_BRIGHTNESS="$((CUR_BRIGHTNESS - MIN_BRIGHTNESS))"

  INCREMENT_BY = $1

  SCALE_FACTOR = 1.5


  if [[$INCREMENT_BY -gt 0]]
  then
    #  $TARGET_BRIGHTNESS+1 ensures it never hits zero and gets stuck.
    RES=$( awk -v s="$((TARGET_BRIGHTNESS+1))"\
               -v e="$SCALE_FACTOR"\
               -v i="$INCREMENT_BY"\
    'BEGIN {for (;i > 0; i--) s *= e; printf "%.f\n" s}'\
    )
    if [[$RES -gt $((MAX_BRIGHTNESS-MIN_BRIGHTNESS))]]
    then
      RES=$((MAX_BRIGHTNESS-MIN_BRIGHTNESS))
    fi
        
  elif [[$INCREMENT_BY -lt 0 ]]  
  then
    RES=$( awk -v s="$((TARGET_BRIGHTNESS+1))"\
               -v e="$SCALE_FACTOR"\
               -v i="$(($INCREMENT_BY*-1))"\
    'BEGIN {for (;i > 0; i--) s /= e; printf "%.f\n" s}'\
    )
    if [[$RES -lt 0]]
    then
      RES=0
    fi
  fi
    RES=$((RES + MIN_BRIGHTNESS))


    echo $RES > $BACKLIGHT_PATH


    # Log scale display
    awk -v hi="$((MAX_BRIGHTNESS-MIN_BRIGHTNESS))"\
        -v r="$((RES-MIN_BRIGHTNESS))"\
        -v s="$SCALE_FACTOR"\
        -v i="$RES"\
    'BEGIN {m_hi=log(hi)/log(s); m_i=log(i)/log(s); printf "%.f\n" m_hi/m_i*100}'\
    > ${wob-fifo}


  # debug print
  echo $RES
  '';
in
{
  enviroment.systemPackages = with pkgs; [wob] ;

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
      startup = [
        {command = "tail -f ${wob-fifo} | wob";}
      ];
      # Fetched using wev
      keybindings = {
        "XF86MonBrightnessUp"   = "";
        "XF86MonBrightnessDown" = "";
        "XF86AudioRaiseVolume"  = "";
        "XF86AudioLowerVolume"  = "";
      };
    };
  };
}
