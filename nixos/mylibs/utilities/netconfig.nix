# unbound versus

{
  config,
  lib,
  inputs,
  ...
}:{
  networking =  {
    hosts = { "127.0.0.1" = [];};
#    nameservers = ["9.9.9.9" "8.8.8.8"]; # Breaks cafe wifi
    nftables = {
      enable = true;
      /*
      tables.printer = {
        name = "printer";
        family = "inet";
        enable = true;
        content = ''
       chain input {
         type filter hook input priority 0; policy accept;

         # SNMP (port 161)
         udp dport 161 accept
         tcp dport 161 accept

         # SNMP Traps (port 162)
         udp dport 162 accept
         tcp dport 162 accept

         # Custom service (port 9100)
         udp dport 9100 accept
         tcp dport 9100 accept
       }   
        '';
      };
      */
    };
    networkmanager = {
      enable = true;
      dns =  lib.mkForce "default";
    };
   #wireless.enable = lib.mkForce false;
  };

}
