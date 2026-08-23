{
  inputs = {  
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nix-unstable-raw.url = "github:NixOS/nixpkgs/nixos-unstable";
    #nix-razor-raw.url = "github:NixOS/nixpkgs/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ss14 = {
      url = "github:/space-wizards/SS14.Launcher/master";
    };

    # Command-not-found can also be implemented by using nix-index
    # This version pulls pre-generated databases from github
    # saving builtime
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats = {
      url = "github:BirdeeHub/nixCats-nvim";
    };

    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-snapshotter = {
      url = "github:pdtpartners/nix-snapshotter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix2container = {
      url = "github:nlewo/nix2container";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    lorri = {
      url = "github:nix-community/lorri";
    };

    /*
    pidev2 = {
      url = "git://localhost/pidev2";
    };
    */

  };
  outputs = { ... } @ inputs: 
  with inputs;
  let
    extra-args = { 
      defaults = rec {
        system = "x86_64-linux";
        sysversion = "26.05";
        pkgscon = {
          inherit system;
          config.allowUnfree = true;
          config.permittedInsecurePackages = [
           #"qtwebengine-5.15.19"
           "electron-32.3.3"
           "electron-39.8.10"
           "pnpm-10.29.2"
            #"electron-31.7.7"
          ];
          config.android_sdk.accept_license = true;
        };
      };
    };
    secrets = ( import ./secrets.nix {} );
    live-image = (import ./artifacts/live-image.nix (inputs//extra-args));
    BB-image =(import ./artifacts/BB.nix (inputs//extra-args));
    TesseractBuilder = (import ./artifacts/BB.nix (inputs//extra-args));

  in 
  {
    nixosConfigurations."${secrets.hostname}"= nixpkgs.lib.nixosSystem BB-image;
    nixosConfigurations."TesseractBuilder" = nixpkgs.lib.nixosSystem TesseractBuilder;

    /*repl = flake-utils.lib.mkApp {
      drv = pkgs.writeShellScriptBin "repl" ''
        confnix=$(mktemp)
        echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
        trap "rm $confnix" EXIT
        nix repl $confnix
      '';
    */
  };
}
