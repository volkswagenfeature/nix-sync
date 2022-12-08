{lib,pkgs,config, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
	  kitty
	  feh
	 ];
}
