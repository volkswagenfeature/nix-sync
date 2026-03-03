{pkgs,config,...}:
{
  imports = [
    ./git-daemon.nix
  ];
  services.git-daemon = {
    enable = true;
    port = 19418;  # Use custom port for testing
    basePath = "/tmp/test-git";
  };
}
