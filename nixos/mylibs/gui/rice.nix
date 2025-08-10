{lib, pkgs, config, ...}:
let 
  secrets = (import ../../secrets.nix {});
  wallPath = toString (/bulk + "/${secrets.primaryuser}-dropbox" + /Photos/Backgrounds);
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
  environment.systemPackages = [
    backgroundScript
  ];


  stylix = {
    enable = true;
    # polarity = "dark"; # Should only be used for the algo.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/brewer.yaml";
    autoEnable = true;
    #homeManagerIntegration.autoImport = false;
    targets = {
      gnome.enable = false;
    };
  };
  home-manager.users."${secrets.primaryuser}" = {pkgs, ...}:{
    programs = {
      #kitty.settings.background_opacity = "0.3";
      fish.plugins = [
        {
          name = "tidetheme";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "0cf2993d37e317a405114b78df6a5440eeb88bbb";
            sha256 = "x0wwXjKCDwtoUUJaiixeRRt5J6+EFD4Qev6kuOhd9Zw=";
          };
        }
        /* Themes to try:
         https://github.com/oh-my-fish/theme-budspencer
         https://github.com/oh-my-fish/theme-dangerous 
         https://github.com/oh-my-fish/theme-edan
         https://github.com/oh-my-fish/theme-clearance
         https://github.com/aneveux/theme-harleen
         https://github.com/hastinbe/theme-kawasaki
         https://github.com/meverss/barracuda 
         https://github.com/oh-my-fish/theme-bobthefish
         https://github.com/joelwanner/theme-boxfish
         https://github.com/yeseni-today/ays-fish-theme
         https://github.com/hasanozgan/theme-lambda
         https://github.com/chgu82837/theme-PastFish
         https://github.com/rafaelrinaldi/theme-pure
         https://github.com/starship/starship

         */
        ];
    };
    /*
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
    */

  };

}
