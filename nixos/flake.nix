{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:/nix-community/nixvim/nixos-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";

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
