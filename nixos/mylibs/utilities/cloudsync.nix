{libs,pkgs, config, inputs, nix-unstable, ...}:
  let 
    secrets = (import ../../secrets.nix {});
    sync_apps = {
      dbox = {
        local  = /bulk/tristan-dropbox;
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
    casegen = check: var: value: ''
      ${check})
        ${var}="${value}"
        ;;

    '';

    # checkvar is the variable to be checked in the case
    # setvar is the one that gets instatiated
    # Cases is a attribute set with the format:
    # {checkval=string}
    casegen = checkvar: setvar: cases:
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

      esac
      '';
    in
      ( pkgs.lib.foldlAttrs caseopt casestart cases ) + caseend;

      remote-targets = casegen "$1" "PATHS" (
        mapAttrs (k: v: " ${toString v.local} ${toString v.remote} ") sync_apps
      );

      modes = casegen "$2" "FLAGS" {
        firstrun = " --create-empty-src-dirs --resilient --resync -MvP ";
        sync = " --create-empty-src-dirs --resilient -MvP  ";
      };


    rc-bis = pkgs.writeScriptBin "rc-bis" ''
      ${casegen "$1" "PATHS" (mapAttrs (k: v: ' ${toString v.local} ${toString v.remote} ') sync_apps )}

      case $2 in
        firstrun)
          FLAGS=" --create-empty-src-dirs --resilient --resync -MvP "
          ;;
        sync)
          FLAGS=" --create-empty-src-dirs --resilient -MvP  "
        
      esac
    '';

  in
{
  environment.systemPackages = with pkgs; [
    nix-unstable.rclone
    ( pkgs.writeTextDir "rclone.conf" (iniGen config) )
    rc-bis
  ];



  

}
