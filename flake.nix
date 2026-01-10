{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    nix-flatpak.url = "github:gmodena/nix-flatpak/";

    nixvim.url = "github:nix-community/nixvim";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    quickshell,
    noctalia,
    nix-flatpak,
    nixvim,
    ...
  }: {
    nixosConfigurations."Nix-Inspiron" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/desktop/configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.uli = import ./home/uli;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
          };
        }
        ./modules/noctalia
      ];
    };
  };
}
