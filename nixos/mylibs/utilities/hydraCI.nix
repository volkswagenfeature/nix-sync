{config, pkgs, ...}:
{
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
    listenHost = "localhost";
  };
  # https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes#Rules
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/nftables.nix
  # networking.nftables.tables.hydra = {};


  networking.firewall.extraInputRules = pkgs.lib.concatLines [
    ''nft add chain inet myapp input { 
      type filter hook input priority 0; 
      policy accept; 
    }''
    "nft add rule inet myapp input tcp dport 3000 drop"
  ];
}
