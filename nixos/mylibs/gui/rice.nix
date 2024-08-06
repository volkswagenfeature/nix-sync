{lib, pkgs, config, ...}:
let 
  secrets = (import ../../secrets.nix {});
  wallPath = /bulk + "/${secrets.primaryuser}-dropbox" + /Photos/Backgrounds;
  swap-delay = "10m";
  backgroundScript = pkgs.writeShellApplication {
    name = "backgroundScript";
    runtimeInputs = [pkgs.swaybg pkgs.findutils pkgs.imagemagick];
    text = ''
      while true; do
        find ${wallPath} -type f \
          -exec magick identify {} \;\
          -exec swaybg --image {} --mode fill \;\
          -exec sleep ${swap-delay} \;
      done
    '';
  };
in
{
  environment.systemPackages = [backgroundScript];
  home-manager.users."${secrets.primaryuser}" = {pkgs, ...}:{
    programs = {
      kitty.settings.background_opacity = "0.3";
    };
    wayland.windowManager.sway = {
      config.gaps = {
        inner = 5;
        outer = 10;
      };
      config.startup = [{command = "${backgroundScript}/bin/backgroundScript";}];
      extraConfig = ''
        blur enable
        default_dim_inactive 0.3
        corner_radius 5
        blur_radius 7 
        blur_contrast 0.5
      '';
    };

  };

}
