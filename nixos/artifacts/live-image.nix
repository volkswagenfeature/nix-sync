{...} @ inputs:
with inputs;

# Sets system and sysversion
#with inputs.defaults;
let
  secrets = (import ../secrets.nix {})//{
    primaryuser = "NixOS";
    hostname = "RecoveryISO";
  };
in
{
  
  system = defaults.system;
  modules = [
    ({pkgs, ...}@mo_in:
    let
      v = builtins.trace mo_in mo_in;
    in
    {
      boot.loader.systemd-boot.enable = true;
      users.users."${secrets.primaryuser}"={
        isNormalUser = true;
      };
      # Temporarily wonky. I'm just ignoring it, and
      # disabling home-manager instead.
      /*
      home-manager.users."${secrets.primaryuser}" = {pkgs, ...}:{               
        home.stateVersion = "${defaults.sysversion}";
      };   
      */
    })
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ({pkgs,...}@args:  
      (removeAttrs ( import ../mylibs/terminal.nix args ) ["home-manager"])
    )
    #../mylibs/system.nix
   
    ({pkgs,...}@args:  
      (removeAttrs ( import ../mylibs/system.nix args ) ["home-manager"])
    )
    
  ];
    specialArgs = {
    inherit inputs;                                                             
    #nix-unstable = inputs.nix-unstable-raw.legacyPackages.${system};           
    nix-unstable = import inputs.nix-unstable-raw {                             
      system = "${system}";                                                     
      config.allowUnfree = true;                                                
    };                                                                          
  };
}
