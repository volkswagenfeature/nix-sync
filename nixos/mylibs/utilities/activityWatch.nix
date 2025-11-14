{libs,pkgs,config,inputs,...}:
let
  secrets = (import ../../secrets.nix {});
in
{
  environment.systemPackages = with pkgs; [
    activitywatch
  ];

  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{
    services.activitywatch = {
      enable = true;
    };
  };
}
