{libs, pkgs, config, inputs, ...}:
let

  dlPath = /bulk/downloads-mountpoint;

  needsPorting= true;

  realUsers = pkgs.lib.attrsets.filterAttrs 
    (n: v: v.createHome) 
    config.users.users;
in
  # Create <dlpath>/<user>/ for each user with a home directory
  systemd.tmpfiles.rules = (pkgs.lib.attrsets.mapAttrsToList 
    (k: v: 
      let path = builtins.toString (dlPath + "/${k}"); in 
      ''d ${path} 700 ${k} ${v.group} - -''
    )
    realUsers
  ) + if needsPorting then [] else (
    []
  );



