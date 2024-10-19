{ enviroment,libs, pkgs, config, inputs, nix-unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    jq
    jd-diff-patch
  ];
}
