{lib,...}:
{
  config = {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };
    virtualisation.incus.enable = true;
    virtualisation.lxd.enable = true;
    systemd.services.lxd.wantedBy = lib.mkForce [];
  };
}

