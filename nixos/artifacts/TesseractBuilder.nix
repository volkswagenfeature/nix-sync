{...} @ inputs: 
with inputs;
let
  secrets = {} // {
    primaryuser = "TesseractEngine";
    hostname = "TesseractBuilder";
  };
  stripHm = modPath: {...}@args: (removeAttrs (import modPath args) ["home-manager"]);
in
rec{
  system = builtins.currentSystem;
  modules = [
    ({...}:{user.users."${secrets.primaryuser}"={
      isNormalUser = true;
    };})
    ({nixpkgs,...}:{ 
     environment.systemPackages = with pkgs; [ 
      git 
      nom
     ];
     nh = {
      enable = true;
      # flake =  # Might be needed???
     };
     })
    # (stripHm ../mylibs/terminal.nix) # Shouldn't actually be needed.
    (stripHm ../mylibs/system.nix)
    (stripHm ../mylibs/packsets/cloud-engineering.nix)

  ];
  specialArgs = {};
}
  
