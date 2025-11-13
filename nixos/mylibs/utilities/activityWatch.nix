{libs,pkgs,config,inputs,...}:
let
  secrets = (import ../../secrets.nix {});
in
{
  home-manager.users."${secrets.primaryuser}"= {pkgs,...}:{
    services.activitywatch = {
      enable = true;
    };
  };
  /*
  config.environment.systemPackages = with pkgs; [

  ];
  */

}
