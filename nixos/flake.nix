{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager";
        follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit nixpkgs;
      system = "x86_64-linux";
    in {
      modules = 
        [
          ./configuration.nix
	 
        ];

  };
}
