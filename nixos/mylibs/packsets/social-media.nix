/*
A graphical package set
Communications and stuff I do social media with.
*/
{pkgs,...}:
{
  config.environment.systemPackages = with pkgs; [
    discord
    webcord-vencord
    element-desktop
    telegram-desktop
    signal-desktop
    # Need a whatsapp tool
    zulip
    zulip-term
    slack
  ];
}
