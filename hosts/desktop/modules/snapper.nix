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

  system.activationScripts.snapper-post-switch = {
  supportsDryRun = true;
  text = ''
    # Verifica se o snapper está disponível e se a config 'root' existe
    if [ -e /run/current-system ] && ${pkgs.snapper}/bin/snapper -c root list > /dev/null 2>&1; then
      echo "Criando snapshot para a nova geração..."
      
      # Obtém o número da geração atual para usar na descrição
      GEN_NUM=$(readlink /nix/var/nix/profiles/system | cut -d- -f2)
      
      ${pkgs.snapper}/bin/snapper -c root create \
        --description "NixOS Generation $GEN_NUM" \
        --cleanup-algorithm number \
        --userdata "type=nixos-generation,gen=$GEN_NUM"
    else
      echo "Snapper não configurado ou primeira instalação; pulando snapshot."
    fi
  '';
};

}
