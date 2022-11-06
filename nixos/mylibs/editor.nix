{lib, pkgs, config, ...}:
with lib;
{
    environment.systemPackages = with pkgs; [ vim_configurable ];
}
