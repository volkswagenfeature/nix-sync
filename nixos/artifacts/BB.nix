{...} @ inputs:
with inputs;
let
  system = defaults.system;
  secrets = (import ../secrets.nix {});
  sysversion = defaults.sysversion;
  /*
  gitmessage = pkgs: rev:( 
    pkgs.stdenvNoCC.mkDerivation {
      name = "latest-message";
      src = ./.;
      installPhase = "git log --format=%B -n 1 20eeba1f6e8cbd74a73f4c4a556f5092530ab175 > $out/res";
    }
  );
  
  gitmessage = pkgs: (pkgs.runCommand "" {} ''
    ${pkgs.git}/bin/git log --format=%B -n 1 20eeba1f6e8cbd74a73f4c4a556f5092530ab175 > $out
  '');
  */
  gitmessage = pkgs: (pkgs.runCommandWith {
      name = "gitmessage";
      derivationArgs.src = ./../..;
    } ''
      ls -a $src
      ${pkgs.git}/bin/git log --format=%B -n 1 HEAD
      echo -n 'hello-thar' > $out
    '' 
  );


in
rec {
  inherit system;
  modules = [ 
    (

      { pkgs, ... }: {
      # Let 'nixos-version --json' know about the Git revision
      # of this flake.
      system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
      system.stateVersion = "${sysversion}";
      system.nixos.tags = [ 
        #(builtins.readFile "${gitmessage pkgs}" )
      ] ;

      #nix.package = nixVersions.stable;
      nix.settings.experimental-features = "nix-command flakes ";
      nix.settings.allow-dirty = true;
      nixpkgs.config = defaults.pkgscon.config;

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
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim 
    nix-index-database.nixosModules.nix-index
  ];

  specialArgs = {
    inherit inputs;
    #nix-unstable = inputs.nix-unstable-raw.legacyPackages.${system};
    nix-unstable = import inputs.nix-unstable-raw defaults.pkgscon ;
    nix-razor = import inputs.nix-razor-raw defaults.pkgscon ;
  };
}
