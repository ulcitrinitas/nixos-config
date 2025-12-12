{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "uli";
  home.homeDirectory = "/home/uli";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ulisses Silva";
        email = "uli.citrinitas@gmail.com";
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-files#Nixos-Inspiron";
    };
    profileExtra = ''

      export PATH="$HOME/.local/bin:$PATH"

    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza";
      ll = "eza --long -bF";
      la = "eza -l -a --group-directories-first";
      lx = "eza -l -a --group-directories-first --extended";
      lt = "eza --tree --long";
      
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-files#Nixos-Inspiron";
      update = "sudo nixos-rebuild switch --flake ~/nix-files#Nixos-Inspiron";
      
      cls = "clear";
      rn = "reset";

      e = "emacsclient -c -a 'emacs'"; # Abre o Emacs no modo gráfico (frame) conectando ao daemon
      et = "emacsclient -t -a 'emacs'"; # Abre o Emacs dentro do próprio terminal (útil para edições rápidas via ssh ou tty)
      ekill = "emacsclient -e '(kill-emacs)'"; # Mata o daemon caso precise recarregar configurações travadas

    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];

    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "wushenrong/zsh-eza";}
        {name = "zsh-users/zsh-syntax-highlighting";}
      ];
    };

    initContent = ''
      eval "$(mise activate zsh)"

    '';
  };

  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs
    chromium
    vscode
    jetbrains-toolbox
    neovim
    # emacs-git
    emacs-pgtk
  ];

  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # Certifique-se de usar o mesmo pacote que instalou (ex: emacs-pgtk ou emacs-git)
    client.enable = true;     # Substitui o ícone do menu para abrir o emacsclient em vez de uma nova instância
    defaultEditor = true;     # Define o editor padrão do sistema (EDITOR) para o emacsclient
  };


  home.file = {
    ".config/niri".source = ./config/niri;
    ".config/alacritty".source = ./config/alacritty;
    ".config/nvim".source = ./config/nvim;
    ".config/mise.toml".source = ./config/mise.toml;
    ".emacs.d".source = ./config/emacs.d;
  };
}
