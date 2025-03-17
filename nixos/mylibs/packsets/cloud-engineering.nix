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
      networking.wireguard.interfaces = {
        wg0 = {
          ips = ["10.100.0.2/24"];
          listenPort = 51820; # From nixos.wiki
          privateKeyFile = secrets.wireguard_keys.paths[0];
          peers = secrets.wireguard.peers;
        };
      };

      services.tailscale.enable = true;

    };
  }

