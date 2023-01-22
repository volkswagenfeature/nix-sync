{config, lib, pkgs, modulesPath, ...}:
with lib;
{
  nix.settings = {
    substituters = ["https://app.cachix.org/cache/cuda-maintainers"];
    trusted-public-keys = ["cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="];
  };
  enviroment.systemPackages = with pkgs; lib.traceVal [
   firefox 
  ];


}
