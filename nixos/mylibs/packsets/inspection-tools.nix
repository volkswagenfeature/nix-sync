{pkgs,...}:
with pkgs;
[
  pciutils
  lshw
  vulkan-tools
  minicom
  usbutils
  dmidecode #Analyze what's in SMBIOS flash

  cryptsetup
  btrfs-progs

]
