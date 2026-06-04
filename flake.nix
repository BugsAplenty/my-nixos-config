{
  description = "My Unified NixOS + Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-ext.url = "github:nix-community/nix-vscode-extensions";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        myhostname = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration/configuration.nix
            ./modules/helm.nix

            home-manager.nixosModules.home-manager

            {
              nixpkgs.overlays = [
                inputs.vscode-ext.overlays.default
                (import ./overlays/helm-with-plugins.nix)
              ];

              nixpkgs = {
                config = {
                  allowUnfree = true;
                  cudaSupport = true;
                  cudaCapabilities = [ "8.6" ];
                };
              }; 

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.razboy = import ./home/home.nix;
                sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
                backupFileExtension = "backup";
              };
            }
          ];
        };
      };

      homeConfigurations = {
        razboy = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.vscode-ext.overlays.default
            ];
            config.allowUnfree = true;
          };

          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home/home.nix ];
        };
      };
    };
}