{ config, lib, pkgs, modulesPath, ... }:
let
  secrets = (import ./secrets.nix {});
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/1982d770-324c-4bc6-aa79-1f54aa18ec42";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/7FC7-0A23";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/b6267e25-5b59-47eb-9477-38920ea74512";
      fsType = "btrfs";
      options = ["subvol=home" ];
    };

  fileSystems."/home/${secrets.primaryuser}/bulk" =
    { device = "/dev/disk/by-uuid/b6267e25-5b59-47eb-9477-38920ea74512";
      fsType = "btrfs";
      options = ["subvol=bulk" ];
    };

  boot.initrd.luks.devices."enc" = 
    { device = "/dev/disk/by-uuid/ffd43f69-4797-4598-a1d9-c6aa6a0c30d0";
      #header = "/root/header.img";
      allowDiscards = true;
    };

  fileSystems."/nix-sync/nixos" =
    { device = "/etc/nixos";
      options = [ "bind" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1694b659-3d72-440c-8a58-e4277660d78a"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
