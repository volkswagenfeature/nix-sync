{
  pkgs,
  ...
}:{
  environment.systemPackages = with pkgs; [
    bisq2
  ];

}
