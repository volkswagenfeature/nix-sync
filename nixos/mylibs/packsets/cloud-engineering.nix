{lib,pkgs,...}:
let
  secrets = (import ../../secrets.nix {});
  
  # whatever is in hello.nix

in
  {
    config = {
      environment.systemPackages = with pkgs; [
        dive
        wireguard-tools
        opentofu
        # App for working with dockertools
        nix-prefetch-docker

        docker-compose

        # Emulator program
        quickemu


      ];

      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };
      # Temporarily disabled, due to build issues.
      # services.tailscale.enable = true;
    };
  }

