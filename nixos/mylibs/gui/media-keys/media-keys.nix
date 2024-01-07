{config, pkgs, lib, ...}:
let
  secrets  = (import ../../../secrets.nix {});

in
{
  imports = [
    ./brightness_monofile.nix
  ];
  home-manager.users."${secrets-primaryuser}".
  wayland.windowManager.sway.config.keybindings = {
    "XF86AudioRaiseVolume" = "exec pamixer -i 10 --get-volume > ${wob-fifo}";
    "XF86AudioRaiseVolume" = "exec pamixer -d 10 --get-volume > ${wob-fifo}";
  };
  
}

