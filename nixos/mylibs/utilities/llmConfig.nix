{
  pkgs,
  ...
}:let
  secrets = (import ../../secrets.nix {});

in {
  environment.systemPackages = with pkgs; [
    llm
  ];
}
