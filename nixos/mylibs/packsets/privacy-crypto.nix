{
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [
    bisq2

    #ipfs
    gx
    #iroh
    ipget
    kubo 
  ];

}
