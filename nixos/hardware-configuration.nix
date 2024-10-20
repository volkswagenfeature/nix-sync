# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let
   secrets = (import ./secrets.nix {});
in
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" "mt7921e" ];
  # boot.kernelParams = [ "amd_iommu=off" "iommu=soft" ]; # Doesn't fix resume.
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.resumeDevice = "/dev/disk/by-uuid/54d8eb27-9f0e-42b1-8457-2ec7f3577085";
  # security.protectKernelImage = false; # Also to allow for resuming
  # Resume offset variable????



  # LUKS unlock
  boot.initrd.luks.devices = {
    crypt = {
      device = "/dev/disk/by-label/crypt-part";
      preLVM = true;
    };
  };


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f6a5f3b4-d5b3-45df-82f7-9f0b59d633fc";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/nix/store" =
    { device = "/dev/disk/by-uuid/f6a5f3b4-d5b3-45df-82f7-9f0b59d633fc";
      fsType = "btrfs";
      options = [ "subvol=nix-store" ];
    };

  fileSystems."/bulk" =
    { device = "/dev/disk/by-uuid/f6a5f3b4-d5b3-45df-82f7-9f0b59d633fc";
      fsType = "btrfs";
      options = [ "subvol=bulk" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/f6a5f3b4-d5b3-45df-82f7-9f0b59d633fc";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/efi" =
    { device = "/dev/disk/by-uuid/020C-0253";
      fsType = "vfat";
    };
  fileSystems."/nix-sync/nixos" = 
    { device = "/etc/nixos";
      options = [ "bind" ];
    };
  swapDevices = [ { device = "/dev/disk/by-uuid/54d8eb27-9f0e-42b1-8457-2ec7f3577085"; } ]; 

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp193s0f3u1c2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # Power management? It was in the old file...
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
