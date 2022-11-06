{ config, pkgs, ... }:
let
  # Programatic way to get the proper version. Does not work. 
  # both config and pkgs rely on this, so if this relies on them
  # you get infinite looping.
  # see https://stackoverflow.com/questions/73845085
  inherit (pkgs.system) stateVersion;
  hm-archive = builtins.trace "release-${stateVersion}.tar.gz" {};

  # Fixed version evaluation as a workaround
  hm-fixed ="release-22.05.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/${hm-fixed}";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
}
