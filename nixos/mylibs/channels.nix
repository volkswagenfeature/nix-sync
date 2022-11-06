{pkgs, ...}:
{
  # Eventually, you'll just be able to put all your extra stuff to be imported here
  # Doesn't work yet.
  #extraTarballs = {
  #  home-manager = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  #};
  #loadTarballs = url : builtins.fetchTarball "${url}";
  #loaded = builtins.mapAttrs loadTarballs extraTarballs;


  #Manual version.
  imports = [
    (
      let
        home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
      in  "${home-manager}/nixos"
      
    )
  ];
}
