{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nix-unstable-raw.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:/nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

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
  };
  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  with inputs;
  let 
    system = "x86_64-linux";
    secrets = ( import ./secrets.nix {} );

  in 
  {
    nixosConfigurations."${secrets.hostname}"= nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [ ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            system.stateVersion = "23.11";
          })

          ./configuration.nix 
          inputs.home-manager.nixosModules.home-manager
          inputs.nixvim.nixosModules.nixvim
          flake-cnf.nixosModules.programs-sqlite
        ];
        specialArgs = {
          inherit inputs;
          nix-unstable = inputs.nix-unstable-raw.legacyPackages.${system};
        };
    };
  };
}
