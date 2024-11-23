{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-unstable-raw.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:/nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.flake-utils.follows = "flake-utils";
    };
/*
    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # A flake-compliant system for command-not-found suggestions
    flake-cnf = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
*/
    # Command-not-found can also be implemented by using nix-index
    # This version pulls pre-generated databases from github
    # saving builtime
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { ... } @ inputs: 
  with inputs;
  let
    extra-args = { 
      defaults = {
        system = "x86_64-linux";
        sysversion = "24.11";
      };
    };
    ssss = v: builtins.trace v v;
    secrets = ( import ./secrets.nix {} );
    live-image = (import ./artifacts/live-image.nix (inputs//extra-args));
    BB-image =(import ./artifacts/BB.nix (inputs//extra-args));

  in 
  {
    nixosConfigurations."${secrets.hostname}"= nixpkgs.lib.nixosSystem BB-image;
    repl = flake-utils.lib.mkApp {
      drv = pkgs.writeShellScriptBin "repl" ''
        confnix=$(mktemp)
        echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
        trap "rm $confnix" EXIT
        nix repl $confnix
      '';
    };
    nixosConfigurations.live-image = (nixpkgs.lib.nixosSystem live-image);
    iso = self.nixosConfigurations.live-image.config.system.build.isoImage;
  };
}
