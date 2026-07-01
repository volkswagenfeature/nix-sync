{
  pkgs,
  inputs,
  system,
  defaults,
  ...
}:let
  secrets = (import ../../secrets.nix {});


in {
  environment.systemPackages = with pkgs; [
    llm 
    inputs.pidev2.packages.${inputs.defaults.system}.pi 
  ];
}
