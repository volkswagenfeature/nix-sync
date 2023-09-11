{config, lib, pkgs, modulesPath, ...}:
with lib;
{
  nix.settings = {
    extra-substituters = ["https://app.cachix.org/cache/cuda-maintainers"];
    trusted-public-keys = ["cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="];
  };

  hardware.opengl.enable = true;
  virtualisation.docker = { 
    enable = true;
    enableNvidia = true;
  }
  lolhi
  enviroment.systemPackages = with pkgs; lib.traceVal [
  ];


}
