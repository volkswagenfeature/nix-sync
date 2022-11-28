{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      # This isn't the problem...
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  with inputs;
  let system = "x86_64-linux";
  in 
  {
    nixosConfigurations.BetaBlue-NixOS-2022 = nixpkgs.lib.nixosSystem {
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
          ./configuration.nix 

          inputs.home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #} 
          inputs.nixvim.nixosModules.nixvim
          {


          }
        ];
        specialArgs = {inherit inputs;};
    };
  };
}
