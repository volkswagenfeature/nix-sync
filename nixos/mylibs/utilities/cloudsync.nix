{libs,pkgs, config, inputs, nix-unstable, ...}:
  let 
    secrets = (import ../../secrets.nix {});

    config = secrets.rclone.config;

    iniGen = ( with pkgs.lib.generators; toINI {
      mkKeyValue = mkKeyValueDefault { 
        mkValueString = v:
          if builtins.typeOf v == "set"
          then builtins.toJSON v 
          else mkValueStringDefault {} v;
      } " = ";
    } 
    );
    trace = pkgs.lib.debug.traceVal ( iniGen config );
  in
{
  environment.systemPackages = with pkgs; [
    rclone
    ( pkgs.writeTextDir "rclone.conf" (iniGen config) )
  ];



  

}
