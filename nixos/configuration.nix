# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, nixpkgs, ... }:
with nixpkgs.lib;
with nixpkgs.lib.debug;
with builtins;
let
  # autodetect = (x: (builtins.trace x x)) 
  autodetect =  []; 
in
{
  imports = autodetect ++
    [ # Include the results of the hardware scan.
      #./imports/HomeManager.nix
      ./mylibs/editor.nix
      ./mylibs/terminal.nix
      ./mylibs/system.nix
      #./hardware-configuration.nix
    ];


  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';


  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


   # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
