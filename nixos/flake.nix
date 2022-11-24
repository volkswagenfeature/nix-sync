{
  inputs = {  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";

    homemanager = {
      url = "github:nix-community/home-manager";
      follows = "nixpkgs";
    };
  };
  outputs = { self,  ... } @ inputs: 
  with inputs;
  let system = "x86_64-linux";
  in 
  {

    nixosConfigurations.BetaBlue-NixOS-2022= nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [ ({ pkgs, ... }: {
            boot.isContainer = true;

            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

            # Network configuration.
            #networking.useDHCP = false;
            #networking.firewall.allowedTCPPorts = [ 80 ];

            # Enable a web server.
            #services.httpd = {
            #  enable = true;
            #  adminAddr = "morty@example.org";
            #};
          })
          ./configuration.nix 
          #./nixos/configuration.nix
        ];
        specialArgs = {inherit inputs;};
    };
  };
}
