{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";

    };
    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  with inputs;
  let system = "x86_64-linux";
  in 
  {
    nixosConfigurations.WSL-NixOS-2023 = nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [ ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            #nixpkgs.overlays = [
            #  (_: _: {
            #    home-manager = inputs.home-manager;
            #  })
            #];
          })

          inputs.NixOS-WSL.nixosModules.wsl
          inputs.home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #} 
          inputs.nixvim.nixosModules.nixvim
          ./configuration.nix

          {
            wsl = {
              enable = true;
              wslConf.automount.root = "/mnt";
              defaultUser = "tristan";
              startMenuLaunchers = true;

              # Enable native Docker support
              # docker-native.enable = true;

              # Enable integration with Docker Desktop (needs to be installed)
              # docker-desktop.enable = true;

            };
          }
        ];
        specialArgs = {inherit inputs;};
    };
  };
}
