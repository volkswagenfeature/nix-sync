/*
Plover — OpenSteno stenography software.

Plover turns a steno machine (or an NKRO QWERTY keyboard acting as one) into a
stenotype and translates strokes into text by creating a *virtual* keyboard on
the fly and writing translated keystrokes out through it.

Running under (Sway/)Wayland rules out Plover's X11/Xlib output backend — the
evdev/uinput backends are the ones that actually work here.  Both need
permissions this module grants:

  - /dev/input/event*  (root:input, mode 0660, no seat ACL by default)
    Plover *reads* raw key events from the steno keyboard here, so the user
    must be a member of the `input` group.

  - /dev/uinput        (root:root,  mode 0660)
    Plover *writes* translated strokes out through a virtual keyboard it
    creates on /dev/uinput.  Steam coincidentally tags uinput with `uaccess`
    (granting the active seat user an ACL), but relying on that is fragile, so
    this module adds a dedicated udev rule giving the `input` group access.
*/
{ pkgs, lib, ... }:
let
  secrets = (import ../../secrets.nix {});
in
{
  # The GUI app itself. Per-user: it's a personal desktop tool, and
  # `users.users.<name>.packages` is a list option, so this merges with the
  # packages already declared for this user elsewhere (system.nix, apps.nix).
  users.users."${secrets.primaryuser}".packages = with pkgs; [
    plover
  ];

  # Read access to /dev/input/event* so Plover can capture the steno keyboard.
  # `extraGroups` is a list option and merges with the groups assigned in
  # system.nix (wheel, networkmanager, ...).
  users.users."${secrets.primaryuser}".extraGroups = [ "input" ];

  # Make sure the uinput module is present at boot.
  boot.kernelModules = [ "uinput" ];

  # Write access to /dev/uinput so Plover can emit translated keystrokes.
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';
}
