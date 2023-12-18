# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, nixpkgs, lib , ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./imports/HomeManager.nix
      ./mylibs/editor.nix
      ./mylibs/terminal.nix
      ./mylibs/system.nix
      #./mylibs/gui/xserver.nix
      ./mylibs/gui/apps.nix
      ./mylibs/gui/sway.nix
    ];

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
