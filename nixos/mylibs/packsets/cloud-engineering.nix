{lib,...}:
{
  config = {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };
    virtualisation.lxd.enable = true;
    systemd.services.lxd.wantedBy = lib.mkForce [];
  };
}

