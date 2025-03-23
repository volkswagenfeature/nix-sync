{lib,pkgs,...}:
let
  secrets = (import ../../secrets.nix {});
in
  {
    config = {
      environment.systemPackages = with pkgs; [
        dive
        wireguard-tools
        opentofu
      ];

      virtualisation.docker = {
        enable = true;
        enableOnBoot = false;
      };
      virtualisation.incus.enable = true;
      virtualisation.lxd.enable = true;
      systemd.services.lxd.wantedBy = lib.mkForce [];

      # vpn configuration. Might belong in a different file?

      networking.wireguard.enable = true;
      networking.wg-quick.interfaces.wg0.configFile = "/home/${secrets.primaryuser}/.ssh/wireguard.conf";
        

      services.tailscale.enable = true;

    };
  }

