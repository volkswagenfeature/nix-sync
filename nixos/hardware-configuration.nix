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
/*
  # flashdrive temp fix 
  fileSystems."/home" = 
    { device = "/dev/disk/by-uuid/04a3cc18-e16c-4ed1-9932-e81a293529d4";
      fsType = "ext4";
    };
*/
  # SD card busted filesystems.
  /*

/dev/sda4: UUID="b6267e25-5b59-47eb-9477-38920ea74512" UUID_SUB="8dc5f03d-82a0-473e-99c6-8759ad29df06" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="842f8f13-12aa-3c46-8063-358154c2b7ff"
/dev/sda2: SEC_TYPE="msdos" UUID="962A-5F50" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="411c6214-dd89-1541-8ff3-2a7103f4b65e"
/dev/sda5: UUID="1982d770-324c-4bc6-aa79-1f54aa18ec42" BLOCK_SIZE="4096" TYPE="ext4" PARTLABEL="root" PARTUUID="40f88ab3-8871-3441-9bfd-fc4cbaa007cf"
/dev/sda3: UUID="1694b659-3d72-440c-8a58-e4277660d78a" TYPE="swap" PARTUUID="8cd364a7-88b8-4a4f-bc8f-58795accac52"
/dev/sda1: UUID="7FC7-0A23" BLOCK_SIZE="512" TYPE="vfat" PARTLABEL="EFI-SYSTEM" PARTUUID="319b3741-7bc8-ba45-94ba-dc9acfb402da"
/dev/sdb: UUID="ffd43f69-4797-4598-a1d9-c6aa6a0c30d0" TYPE="crypto_LUKS"
/dev/mapper/enc: UUID="863256c3-63d8-4530-abf0-af5e2fc3f96d" UUID_SUB="2cf6473d-117b-439c-822d-1945287874cf" BLOCK_SIZE="4096" TYPE="btrfs"
*/

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
/*
  # broken.
  fileSystems."/home/${secrets.primaryuser}/bulk/dropbox" =
    { device = "/dev/disk/by-uuid/863256c3-63d8-4530-abf0-af5e2fc3f96d";
      fsType = "btrfs";
      options = ["subvol=dropbox"];
    };
*/


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
