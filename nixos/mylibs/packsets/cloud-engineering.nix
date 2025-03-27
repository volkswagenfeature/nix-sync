{lib,pkgs,...}:
let
  secrets = (import ../../secrets.nix {});
  
  wg = pkgs.callPackage ../../wireguard.nix {} ;
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
      networking.wireguard.interfaces.wg1 = {
        #listenPort = 51820;
        privateKeyFile = builtins.elemAt secrets.wireguard.private_paths 0;
        peers = secrets.wireguard.peers;
      };

/*
      networking.wg-quick.interfaces.wg0 = {
        autostart = false;
        configFile = "/home/${secrets.primaryuser}/.ssh/wireguard.conf";
      };

      systemd.services.wg-quick-wg0  = { 
        wantedBy = lib.mkForce ["network-online.target"];
        after = [ "network-online.target" ];
        #requires = ["wireguard.service"];
      };
*/
      /*
      systemd.services.wireguard = {
        wantedBy = lib.mkForce ["wg-quick-wg0.service"];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
      */

        

      services.tailscale.enable = true;
    };
  }

