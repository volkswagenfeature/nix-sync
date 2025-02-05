{...} @ inputs:
with inputs;
let
  system = defaults.system;
  secrets = (import ../secrets.nix {});
  sysversion = defaults.sysversion;

  gitmessage = checkrev : 
    with nixpkgs.lib;
    let
      lastcommit = ../.lastcommit.json;
      commitjson = trivial.importJSON lastcommit;
      truncate = str: len: ( 
        strings.concatImapStrings 
         (i: a: if i <= len then a else "")
         ( strings.stringToCharacters str )
      );
    in 
      (
        assert builtins.pathExists (debug.traceVal lastcommit);
        assert commitjson.commit == checkrev;
        debug.traceVal strings.sanitizeDerivationName ( 
          truncate ( 
            builtins.elmAt ( 
              strings.splitString "\n" ( commitjson.message )
            ) 0
          ) 30       
        )
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
        (gitmessage system.configurationRevision)
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
