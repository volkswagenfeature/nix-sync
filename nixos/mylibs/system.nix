{lib, pkgs, config, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
    home-manager

  ];

  # ssh-agent config
  programs.ssh.startAgent = true;



  # Homemanager configs
  # users.users.nixos.isNormalUser = true;
  # home-manager.users.nixos = {pkgs, ...}:{
  #  programs.fish.enable = true;

  # };






}
