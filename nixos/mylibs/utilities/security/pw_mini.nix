{
  pkgs,
  config,
  ...
}:
let
    newPass = let # Currently needs work. Even Tharvik's branch
                  # doesn't fix the utf8 encoding bug.
      inherit (pkgs) python3 lib fetchFromGitHub;
    in
      python3.pkgs.buildPythonApplication rec {
        pname = "pass-secret-service";
        version = "unstable-2025-08-01";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "tharvik";
          repo = "pass_secret_service";
          rev = "70bac7579edf8436e2c8bc28ec7f883db6af10bb";
          hash = "sha256-X13lTm3+tmBAcX3Bs8YAQOADkBxo7l0zufpRjFOQ0Pw=";
        };

        build-system = [
          python3.pkgs.setuptools
          python3.pkgs.wheel
        ];

        dependencies = with python3.pkgs; [
          dbus-next
          click
          decorator
          coverage
          pycodestyle
          pytest
          pytest-asyncio
          secretstorage
        ];

        pythonImportsCheck = [
          "pass_secret_service"
        ];

        meta = {
          description = "Dbus-service to serve secret-service api with pass backend";
          homepage = "https://github.com/tharvik/pass_secret_service/tree/develop";
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ ];
          mainProgram = "pass-secret-service";
        };
      };
in
{
  environment.systemPackages = with pkgs; [
    (pass.withExtensions (ext: []))
    pass-secret-service
    pinentry-bemenu
    pinentry-tty
  ];
  services.gnome.gnome-keyring.enable = true;
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-bemenu;
    };

  };
  services.passSecretService = { 
    enable = false; 
    # package = pkgs.libsecret;
    package = newPass;
  };
}
