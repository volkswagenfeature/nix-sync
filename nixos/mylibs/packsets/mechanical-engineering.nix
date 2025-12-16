{pkgs,nix-unstable,...}:
with pkgs;
let
  printrun_over = ( self: super:{ 
    printrun = super.printrun.overridePythonAttrs (
      prev:{
        dependencies = [
          pkgs.python312Packages.platformdirs
        ];
      }
    );
  });
in
{
  config.nixpkgs.overlays = [];
  config.environment.systemPackages = with pkgs; [
    #kicad
    freecad-wayland
    meshlab
    prusa-slicer
    printrun
  ];
}
