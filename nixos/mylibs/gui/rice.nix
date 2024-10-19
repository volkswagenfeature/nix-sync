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
      fish.plugins = [
        /*{
        name = "shellder-theme";
          src = pkgs.fetchFromGitHub {
            owner = "simnalamburt";
            repo = "shellder";
            rev = "fcfef62c86fe2857ddac30d8ac36e99e8d765fae";
            sha256 = "sha256-wCtM4D3GEK8pTepzs0YBznSgSOmV+VqdAS7yifosICQ=";
          };
        }*/

        {
          name = "tidetheme";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "0cf2993d37e317a405114b78df6a5440eeb88bbb";
            sha256 = "x0wwXjKCDwtoUUJaiixeRRt5J6+EFD4Qev6kuOhd9Zw=";
          };
        }
        ];
    };
    wayland.windowManager.sway = {
      config.colors.focused = rec {
        border = "#ffffff";
        childBorder = border;
        background = "#cccccc";
        text = "#444444";
        indicator = "#444444";
      };
      config.gaps = {
        inner = 5;
        outer = 10;
      };
      config.startup = [{command = "${backgroundScript}/bin/backgroundScript";}];
      extraConfig = ''
        blur enable
        blur_brightness 0.8
        default_dim_inactive 0.0 
        corner_radius 5
        blur_radius 7 
        blur_contrast 0.5
      '';
    };

  };

}
