# unbound versus

{
  config,
  lib,
  inputs,
  ...
}:{
  networking =  {
    hosts = { "127.0.0.1" = [];};
    nameservers = ["9.9.9.9"];
    nftables.enable = true;
    networkmanager = {
      enable = true;
      # useDnsmasq = true;  # Reccomended to fix the lookup errors
      dns = "default";
    };
    wireless.enable = lib.mkForce false;
  };

}
