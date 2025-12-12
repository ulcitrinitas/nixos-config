{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    quickshell,
    noctalia,
    emacs-overlay,
    ...
  }: {
    nixosConfigurations.Nixos-Inspiron = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        lanzaboote.nixosModules.lanzaboote
        ./configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ emacs-overlay.overlays.default ];
        })
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.uli = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
        ./noctalia.nix
      ];
    };
  };
}
