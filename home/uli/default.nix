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

  imports = [
    ./modules/shell.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    vivaldi-ffmpeg-codecs
    chromium
    vscode
    jetbrains-toolbox
    neovim
    starship
    fastfetch
    btop
  ];

  home.file = {
    ".config/niri".source = ./config/niri;
    ".config/alacritty".source = ./config/alacritty;
    ".config/mise.toml".source = ./config/mise.toml;
  };
}
