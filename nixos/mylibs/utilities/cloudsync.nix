{ libs, pkgs, config, inputs, nix-unstable, ... }:
let
  secrets = (import ../../secrets.nix { });
  logdir = /var/log/bisync-script;
  sync_apps = {
    dbox = {
      local = "/bulk/${secrets.primaryuser}-dropbox";
      remote = "dropbox:";
    };
  };

  ### RCLONE CONFIG STUFF ###
  config = secrets.rclone.config;

  iniGen = (with pkgs.lib.generators;
    toINI {
      mkKeyValue = mkKeyValueDefault
        {
          mkValueString = v:
            if builtins.typeOf v == "set" then
              builtins.toJSON v
            else
              mkValueStringDefault { } v;
        } " = ";
    });

  ### RCLONE SYNC JOB ###
  /* casegen = check: var: value: ''
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
      caseopt = acc: check: value:
        acc + ''
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
    (pkgs.lib.foldlAttrs caseopt casestart cases) + caseend;

  # TODO: Sanitize values going into key-value? 
  # TODO: backslash at end of string would cause issues unless double escaped. 
  # TODO: Other special cases?
  # TODO: redo with a implementation based on lib.cli.toGNUCommandLine

  fformat = flags:
    with pkgs.lib;
    with builtins;
    let
      grouped = (lists.groupBy
        (f:
          if builtins.isAttrs f then
            "keyValue"
          else
            (if builtins.stringLength f > 1 then "longFlag" else "shortFlag"))
        flags);
      mapAttrsToStringSep = sep: func: at:
        (strings.concatStringsSep sep (attrsets.mapAttrsToList func at));
    in
    ((if grouped ? shortFlag then
      (" -" + strings.concatStrings grouped.shortFlag)
    else
      "") + " " + (if grouped ? longFlag then
      (strings.concatMapStringsSep " " (f: "--" + f) grouped.longFlag)
    else
      "") + " " + (if grouped ? keyValue then
      (strings.concatMapStringsSep " "
        (mapAttrsToStringSep " " (k: v: ''--${k}=\"${v}\"''))
        (grouped.keyValue))
    else
      ""));

  remote-targets = casegen "$1" "PATHS"
    (builtins.mapAttrs (k: v: " ${toString v.local} ${toString v.remote} ")
      sync_apps) "echo no targetspec named $1; exit";

  commonflags = (fformat [
    "create-empty-src-dirs"
    "resilient"
    "recover"
    "M"
    "v"
    "P"
    "fix-case"
    {
      compare = "size,checksum";
      max-lock = "3m";
    }
  ]);

  modes = casegen "$2" "FLAGS"
    {
      firstrun = "${commonflags} " + "--resync";
      sync = "${commonflags}";
    } "echo no mode definition for $2; exit";

  # TODO: rewrite with seperate "check" phase if hash isn't speedy.
  # TODO: check phase 1: size and modtime, check phase 2: hash

  bisync = pkgs.writeScriptBin "bisync" ''
    # Select paths to the remote
    ${remote-targets}

    # Select rclone args
    ${modes}

    # Setup logging
    LOGPATH="${toString logdir}/bisync_$1_$2_$(date +%FT%H_%M_%S).log"
    LOGCMD="tee $LOGPATH"

    RCLONE_CMD="rclone bisync $PATHS $FLAGS --log-file \"$LOGPATH\" ''${@:3} "
    echo "Preparing to execute this bisync command:"
    echo $RCLONE_CMD
    echo as $(id)
    read -p "Continue? [y/N] " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]
    then
        eval "$RCLONE_CMD"
    fi
  '';

in
{
  systemd.tmpfiles.rules = [ 
    "d ${toString logdir} 775 ${secrets.primaryuser} users - -" 
  ];
  environment.systemPackages = with pkgs; [
    nix-unstable.rclone
    #(pkgs.writeTextDir "rclone.conf" (iniGen config))
    bisync
  ];
}
