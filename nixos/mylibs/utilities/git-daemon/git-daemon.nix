{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.git-daemon;
in
{
  options = {
    services.git-daemon = {
      enable = mkEnableOption "git daemon service for local development";
      
      port = mkOption {
        type = types.port;
        default = 9418;
        description = "TCP port on which git daemon listens (localhost only)";
      };
      
      basePath = mkOption {
        type = types.path;
        default = "/srv/git";
        description = "Base directory containing git repositories to serve";
      };
      
      user = mkOption {
        type = types.str;
        default = "git";
        description = "User account to run git daemon under";
      };
      
      group = mkOption {
        type = types.str;
        default = "git";
        description = "Group account to run git daemon under";
      };
      
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ "--export-all" "--verbose" ];
        description = "Additional command-line arguments for git daemon";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create git user/group if they don't exist
    users.users = optionalAttrs (!config.users ? ${cfg.user}) {
      ${cfg.user} = {
        uid = config.ids.uids.git;
        group = cfg.group;
        home = "/var/lib/git";
        shell = "/bin/sh";
        description = "Git daemon user for local development";
      };
    };

    users.groups = optionalAttrs (!config.users ? ${cfg.group}) {
      ${cfg.group} = {
        gid = config.ids.gids.git;
        members = [ cfg.user ];
      };
    };

    # Ensure base path has correct permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.basePath} 0755 root ${cfg.group}"
    ];

    systemd.services.git-daemon = {
      description = "Git Daemon - Local Development Git Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = concatStringsSep " " ([
          "${pkgs.git}/bin/git daemon"
          "--port=${toString cfg.port}"
          "--base-path=${cfg.basePath}"
          "--listen=127.0.0.1"  # Explicitly bind to localhost
          "--reuseaddr"
        ] ++ cfg.extraArgs);
        Restart = "on-failure";
        RestartSec = "5";
        WorkingDirectory = cfg.basePath;
      };
      
      preStart = ''
        # Ensure base path exists
        if [ ! -d "${cfg.basePath}" ]; then
          mkdir -p "${cfg.basePath}"
          chown ${cfg.user}:${cfg.group} "${cfg.basePath}"
        fi
        
        # Validate repositories
        find "${cfg.basePath}" -name "*.git" -type d | while read repo; do
          if [ ! -f "$repo/config" ]; then
            echo "WARNING: $repo does not appear to be a valid git repository"
          fi
        done
      '';
    };

    # Add git to system packages if not already present
    environment.systemPackages = [ pkgs.git ];
  };
}