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
  networking.firewall.extraInputRules = [
    ''nft add chain inet myapp input { 
      type filter hook input priority 0; 
      policy accept; 
    }''
    "nft add rule inet myapp input iif lo tcp dport 3000 accept"
    "nft add rule inet myapp input tcp dport 3000 drop"
  ];
}
