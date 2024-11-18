{...} @ inputs:
with inputs;
let
  system = "x86_64-linux";
  secrets = (import ../secrets.nix {});
  sysversion = "24.05";
in
rec {
  inherit system;
  modules = [ 
    ({ pkgs, ... }: {
      # Let 'nixos-version --json' know about the Git revision
      # of this flake.
      system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
      system.stateVersion = "${sysversion}";

      nix.package = pkgs.nixFlakes;
      nix.settings.experimental-features = "nix-command flakes ";
      nixpkgs.config.allowUnfree = true;

      # Enable Homemanager
      home-manager.users."${secrets.primaryuser}" = {pkgs, ...}:{
        home.stateVersion = "${sysversion}";
      };
    })
    ../hardware-configuration.nix
    ../mylibs/editor.nix
    ../mylibs/terminal.nix
    ../mylibs/system.nix
    ../mylibs/gui/apps.nix
    ../mylibs/gui/sway.nix
    ../mylibs/gui/rice.nix
    ../mylibs/gui/firefox.nix
    ../mylibs/utilities/cloudsync.nix
    ../mylibs/utilities/downloadmount.nix
    ../mylibs/utilities/git-script-reqs.nix
    #./mylibs/utilities/testfile.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
    #inputs.flake-cnf.nixosModules.programs-sqlite #Currently broken
    nix-index-database.nixosModules.nix-index
    #"${nix-unstable-raw}/nixos/modules/programs/nh.nix"
  ];

  specialArgs = {
    inherit inputs;
    #nix-unstable = inputs.nix-unstable-raw.legacyPackages.${system};
    nix-unstable = import inputs.nix-unstable-raw {
      system = "${system}";
      config.allowUnfree = true;
      config.permittedInsecurePackages = [
        "electron-25.9.0"
      ];
    };
  };
}
