{pkgs,...}:
{
  config.environment.systemPackages = with pkgs; [
    pciutils
    lshw
    vulkan-tools
    minicom
    usbutils
    dmidecode #Analyze what's in SMBIOS flash
    file 

    cryptsetup
    btrfs-progs

    btop-rocm
    nix-tree
    pv
    neofetch
  ];
}
