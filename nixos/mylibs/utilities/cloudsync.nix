{libs,pkgs, config, inputs, nix-unstable, ...}:
  let 
    secrets = (import ../../secrets.nix {});
    logdir = /var/log/bisync-script;
    sync_apps = {
      dbox = {
        local  = "/bulk/${secrets.primaryuser}-dropbox";
        remote = "dropbox:";
      };
    };


    ### RCLONE CONFIG STUFF ###
    config = secrets.rclone.config;

    iniGen = ( with pkgs.lib.generators; toINI {
      mkKeyValue = mkKeyValueDefault { 
        mkValueString = v:
          if builtins.typeOf v == "set"
          then builtins.toJSON v 
          else mkValueStringDefault {} v;
      } " = ";
    });

    ### RCLONE SYNC JOB ###
    /*
    casegen = check: var: value: ''
      ${check})
        ${var}="${value}"
        ;;

    '';
    */

    # checkvar is the variable to be checked in the case
    # setvar is the one that gets instatiated
    # Cases is a attribute set with the format:
    # {checkval=string}
    casegen = checkvar: setvar: cases: default:
    let
      casestart = ''
      case ${checkvar} in
      '';
      caseopt = acc: check: value: acc+''
      #
        ${check})
          ${setvar}="${value}"
          ;;
      '';
      caseend = ''
        *)
          ${default}
          ;;
      esac
      '';
      
    in
      ( pkgs.lib.foldlAttrs caseopt casestart cases ) + caseend;

      remote-targets = casegen "$1" "PATHS" (
        builtins.mapAttrs (k: v: " ${toString v.local} ${toString v.remote} ") 
        sync_apps
      ) "echo no targetspec named $1; exit";

      modes = casegen "$2" "FLAGS" {
        firstrun = " --create-empty-src-dirs --resilient --resync -MvP ";
        sync = " --create-empty-src-dirs --resilient -MvP  ";
      } "echo no mode definition for $2; exit";


    bisync = pkgs.writeScriptBin "bisync" ''
      # Select paths to the remote
      ${remote-targets}

      # Select rclone args
      ${modes}

      # Setup logging
      LOGCMD="tee ${toString logdir}/bisync_$1_$2_$(date +%FT%H_%M_%S).log"

      RCLONE_CMD="rclone bisync $PATHS $FLAGS ''${@:3} | $LOGCMD "
      echo "Preparing to execute this bisync command:"
      echo $RCLONE_CMD
      read -p "Continue? [y/N] " confirm
      if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
      then
          exec "$RCLONE_CMD"
      fi
    '';

  in
{
  systemd.tmpfiles.rules = ["d ${toString logdir} 775 - users - -"];
  environment.systemPackages = with pkgs; [
    nix-unstable.rclone
    ( pkgs.writeTextDir "rclone.conf" (iniGen config) )
    bisync
  ];
}
