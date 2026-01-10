# modules/nvim.nix
{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Importa o módulo do Nixvim específico para Home Manager
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraPlugins = with pkgs.vimPlugins; [
      onedark-nvim
      catppuccin-nvim
    ];

    # Se você tiver uma configuração antiga do Neovim no HM,
    # certifique-se de que o programs.neovim.enable esteja false.

    viAlias = true;
    vimAlias = true;

    # Configurações de exemplo
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      treesitter.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          lua_ls.enable = true;
        };
      };
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha"; # Opções: latte, frappe, macchiato, mocha
        transparent_background = true;
        term_colors = true;
      };
    };
  };
}
