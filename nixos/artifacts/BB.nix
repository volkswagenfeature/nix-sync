{...} @ inputs:
with inputs;
let
  secrets = (import ../secrets.nix {});

  gitmessage = pkgs: checkrev : 
    with pkgs.lib;
    let
      lastcommit = ../.lastcommit.json;
      commitjson = trivial.importJSON lastcommit ;
      truncate = str: len: ( 
        strings.concatImapStrings 
         (i: a: if i <= len then a else "")
         ( strings.stringToCharacters str )
      );
    in 
      (
        assert builtins.pathExists (lastcommit);
        (
          if (checkrev) != "unknown" 
          then checkrev 
          else "unknown-${truncate commitjson.commit 6}"
        ) + "-" + 
        strings.sanitizeDerivationName ( 
          truncate ( 
            builtins.elemAt ( 
              strings.splitString "\n" ( commitjson.message )
            ) 0
          ) 30       
        ) 
      );
in
rec {
  modules = [ 
    ( { pkgs,  ... }: 
    let
      configurationRevision = "unknown"; 
    in 
    {
      system.stateVersion = defaults.sysversion;
      system.nixos.tags = [ 
        ( pkgs.lib.debug.traceVal (gitmessage pkgs configurationRevision))
      ] ;

      #nix.package = nixVersions.stable;
      nix.settings.experimental-features = "nix-command flakes ";
      nix.settings.allow-dirty = true;
      nixpkgs.config = defaults.pkgscon.config;

      # Enable Homemanager
      home-manager.users."${secrets.primaryuser}" = {pkgs, ...}:{
        home.stateVersion = "${defaults.sysversion}";
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
