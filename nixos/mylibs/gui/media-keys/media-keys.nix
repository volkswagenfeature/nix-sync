{config, pkgs, lib, ...}:
let
  secrets  = (import ../../../secrets.nix {});

in
{
  imports = [
    ./brightness_monofile.nix
  ];
  
}

