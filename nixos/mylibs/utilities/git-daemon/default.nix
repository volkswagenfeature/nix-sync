{pkgs,config,secrets,...}:
let
secrets = (import ../../../secrets.nix {});
in
{
  imports = [
    ./git-daemon.nix
  ];
  # My implementation (disabled)
  /*
  services.git-daemon = {
    enable = true;
    port = 9418;  # Use custom port for testing
    basePath = "/opt/local/test-git";
  };
  */
  services.gitDaemon = {
    basePath = "/opt/local/test-git";
    listenAddress = "localhost";
    group = "users";
    user = "${secrets.primaryuser}";
    enable = true;
  };
}
