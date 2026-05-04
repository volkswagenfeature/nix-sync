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
    nftables.enable = true;
    networkmanager = {
      enable = true;
      dns =  lib.mkForce "default";
    };
    wireless.enable = lib.mkForce false;
  };

}
