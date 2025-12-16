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

    rustPass = let
      inherit (pkgs) lib rustPlatform fetchFromGitHub;
    in
      rustPlatform.buildRustPackage rec {
        pname = "pass-secret-service";
        version = "0.5.1";

        src = fetchFromGitHub {
          owner = "grimsteel";
          repo = "pass-secret-service";
          rev = "v${version}";
          hash = "sha256-Sjq8ABIoT2Sz8ZRx/TPUoUeXU3qOHD/KJQtcGIm7O74=";
        };

        cargoHash = "sha256-lGRdMsBG0IWScDVWRfXtJ/njt5M21CXOCnybw82PwaM=";

        meta = {
          description = "Implementation of org.freedesktop.secrets using `pass";
          homepage = "https://github.com/grimsteel/pass-secret-service/tree/main";
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ ];
          mainProgram = "pass-secret-service";
        };
      };
in
{
  environment.systemPackages = with pkgs; [
    (pass.withExtensions (ext: []))
    #pass-secret-service
    libsecret
    pinentry-bemenu
    pinentry-tty
  ];
  programs.gnupg = {
    agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-bemenu;
    };
  };
  /*
  systemd.user.services."dbus-org.freedesktop.secrets.service" = {
    enable = true;
    description = "grimsteel's secret service implementation";
    partOf = ["graphical-session.target"];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.secrets";
      ExecStart = "${rustPass}/bin/pass-secret-service";
    };
  };
  */

#services.gnome.gnome-keyring.enable = true;
  services.passSecretService = { 
    enable = false; 
    # package = newPass;
  };
}
