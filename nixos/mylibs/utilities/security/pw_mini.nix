{
  pkgs,
  config,
  ...
}:
{
  config.environment.systemPackages = with pkgs; [
    pass
  ];
  config.services.passSecretService.enable = true;

}
