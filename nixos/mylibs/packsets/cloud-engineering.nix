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
      systemd.services.incus.wantedBy = lib.mkForce [];

      virtualisation.lxd.enable = true;
      systemd.services.lxd.wantedBy = lib.mkForce [];

      # vpn configuration. Might belong in a different file?

      networking.wireguard.enable = true;
      networking.wg-quick.interfaces.wg0 = {
        autostart = false;
        configFile = "/home/${secrets.primaryuser}/.ssh/wireguard.conf";
      };
      systemd.services.wg-quick-wg0 = { 
        wantedBy = lib.mkForce ["graphical.target"];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
      systemd.services.wireguard = {
        wantedBy = lib.mkForce ["wg-quick-wg0.service"];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };

        

      services.tailscale.enable = true;

    };
  }

