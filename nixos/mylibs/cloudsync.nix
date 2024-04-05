{libs,pkgs, config, inputs, nix-unstable, ...}:
  let 
    secrets = (import ../secrets.nix {});
  in
{
  enviroment.systemPackages = with pkgs; [
    rclone
  ];




}
