{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "0";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "2";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
    };
  };

  # Script pra rodar quando ocorre criação de novas gerações do sistema
  system.activationScripts.snapperSnapshot = {
    text = ''
      SNAPPER="${pkgs.snapper}/bin/snapper"

      if [ -x "$SNAPPER" ]; then
        # Caminho da nova geração (que está sendo ativada agora)
        NEW_GEN_PATH=$(readlink -f /nix/var/nix/profiles/system)
        # Caminho da geração atual (que ainda está rodando)
        OLD_GEN_PATH=$(readlink -f /run/current-system)

        # Só cria o snapshot se os caminhos forem diferentes
        if [ "$NEW_GEN_PATH" != "$OLD_GEN_PATH" ]; then
          GEN_NUM=$(echo "$NEW_GEN_PATH" | grep -oP 'system-\K[0-9]+')

          echo "NixOS: Detectada nova geração ($GEN_NUM). Criando snapshot Btrfs..."

          $SNAPPER -c root create \
            --description "NixOS Generation $GEN_NUM" \
            --cleanup-algorithm number \
            --userdata "nixos_gen=$GEN_NUM"
        else
          echo "NixOS: Nenhuma mudança de geração detectada. Pulando snapshot."
        fi
      fi
    '';
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nixos-snapshots" ''
      echo "ID | Data | Descrição | Metadados"
      echo "---|------|-----------|----------"
      ${pkgs.snapper}/bin/snapper -c root list --type manual | grep "type=nixos-generation"
    '')
  ];
}
