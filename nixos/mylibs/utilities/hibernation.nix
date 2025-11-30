# Stolen from https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221 
{lib, pkgs, config, ...}:
let
  utility = pkgs.callPackage ../../utility/misc.nix {inherit pkgs;};
  hiberOnWake = utility.fileToStore ../../assets/hiber-on-wake.wav "hiberOnWake.wav";
  hiberScriptRun = utility.fileToStore ../../assets/hiber-on-wake.wav "hiberScriptRun.wav";

  
  hibernateEnvironment = {
    HIBERNATE_SECONDS = "60";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };
  swapPartition = "/dev/disk/by-uuid/54d8eb27-9f0e-42b1-8457-2ec7f3577085";
in {
  boot.kernelParams = ["resume=${swapPartition}"];
  boot.resumeDevice = swapPartition; 

  /*
  systemd.services."awake-after-suspend-for-a-time" = {
    description = "Sets up the suspend so that it'll wake for hibernation";
    wantedBy = [ "suspend.target" ];
    before = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      ${pkgs.pipewire}/bin/pw-play ${hiberOnWake}
      curtime=$(date +%s)
      echo "$curtime $1" >> /tmp/autohibernate.log
      echo "$curtime" > $HIBERNATE_LOCK
      ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
    '';
    serviceConfig.Type = "simple";
  };
  systemd.services."hibernate-after-recovery" = {
    description = "Hibernates after a suspend recovery due to timeout";
    wantedBy = [ "suspend.target" ];
    after = [ "systemd-suspend.service" ];
    environment = hibernateEnvironment;
    script = ''
      ${pkgs.pipewire}/bin/pw-play ${hiberScriptRun}
      curtime=$(date +%s)
      sustime=$(cat $HIBERNATE_LOCK)
      rm $HIBERNATE_LOCK
      if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
        systemctl hibernate
      else
        ${pkgs.utillinux}/bin/rtcwake -m no -s 1
      fi
    '';
    serviceConfig.Type = "simple";
  };
  */
}
