{...} @ inputs:
with inputs;
let
  secrets = (import ../secrets.nix {});

  gitmessage = pkgs: checkrev : 
    with pkgs.lib;
    let
      lastcommit = ../.lastcommit.json;
      commitjson = (assert builtins.pathExists (lastcommit); trivial.importJSON lastcommit) ;
      truncate = str: len: ( 
        strings.concatImapStrings 
         (i: a: if i <= len then a else "")
         ( strings.stringToCharacters str )
      );
      fetch = if (strings.hasSuffix "-dirty" checkrev) then "dirty" else "clean";

    in 
      (
        (
          if (checkrev) != "unknown" 
          then (
            assert commitjson.commit == (strings.removeSuffix "-dirty" checkrev);
            "${fetch}-${truncate checkrev 6}"
          )
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
      configurationRevision = self.rev or self.dirtyRev or "unknown"; 
    in 
    {
      system.stateVersion = defaults.sysversion;
      system.nixos.tags = [ 
        ( pkgs.lib.debug.traceVal (gitmessage pkgs configurationRevision ))
      ] ;

      #nix.package = nixVersions.stable;
      nix.settings.experimental-features = "nix-command flakes";
      nix.settings.connect-timeout = 5;
      nix.settings.stalled-download-timeout = 15;

      nix.settings.allow-dirty = true;
      nixpkgs.config = defaults.pkgscon.config;

      # Enable Homemanager
      home-manager.users."${secrets.primaryuser}" = {pkgs, ...}:{
        home.stateVersion = "${defaults.sysversion}";
      };
    })
    ../hardware-configuration.nix
    ../mylibs/utilities/hibernation.nix
    ../mylibs/terminal.nix
    ../mylibs/system.nix
    ../mylibs/gui/apps.nix
    ../mylibs/gui/sway.nix
    ../mylibs/gui/rice.nix
    ../mylibs/gui/firefox.nix
    ../mylibs/utilities/cloudsync.nix
    ../mylibs/utilities/downloadmount.nix
    ../mylibs/utilities/netconfig.nix
    ../mylibs/utilities/git-script-reqs.nix
    ../mylibs/utilities/neovim/nixcats.nix
    ../mylibs/utilities/security/pw_mini.nix
    ../mylibs/utilities/activityWatch.nix
    # ../mylibs/utilities/hydraCI.nix
    ({ pkgs, ... }: {
      # (1) Import nixos module.
      imports = [ inputs.nix-snapshotter.nixosModules.default ];

      # (2) Add overlay.
      nixpkgs.overlays = [ inputs.nix-snapshotter.overlays.default ];

      # (3) Enable service.
      virtualisation.containerd = {
        enable = true;
        nixSnapshotterIntegration = true;
      };
      services.nix-snapshotter = {
        enable = true;
      };

      # (4) Add a containerd CLI like nerdctl.
      environment.systemPackages = [ pkgs.nerdctl ];
    })

    inputs.home-manager.nixosModules.home-manager
    #inputs.nixvim.nixosModules.nixvim 
    inputs.stylix.nixosModules.stylix
    nix-index-database.nixosModules.nix-index
  ];

  specialArgs = {
    inherit inputs;
    #nix-unstable = inputs.nix-unstable-raw.legacyPackages.${system};
    nix-unstable = import inputs.nix-unstable-raw defaults.pkgscon ;
    nix-razor = import inputs.nix-razor-raw defaults.pkgscon ;
  };
}
