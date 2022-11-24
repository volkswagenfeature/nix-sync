{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  with inputs;
  let system = "x86_64-linux";
  in 
  {
    nixosConfigurations.BetaBlue-NixOS-2022= nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [ ({ pkgs, ... }: {

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            #networking.useDHCP = false;
            #networking.firewall.allowedTCPPorts = [ 80 ];

            #nixpkgs.overlays = [
            #  (_: _: {
            #    home-manager = inputs.home-manager;
            #  })
            #];
          })
          ./configuration.nix 
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkg = true;
            home-manager.useUserPackages = true;
          }
        ];
        specialArgs = {inherit inputs;};
    };
  };
}
