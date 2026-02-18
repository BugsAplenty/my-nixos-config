{
  description = "My Unified NixOS + Home Manager Configuration";
  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-ext.url   = "github:nix-community/nix-vscode-extensions";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, vscode-ext, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    ############################################################################
    # ── NixOS system configuration ───────────────────────────────────────────
    ############################################################################
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
            nixpkgs.config.allowUnfree = true;
            home-manager = {
              useGlobalPkgs    = true;
              useUserPackages  = true;
              extraSpecialArgs = { inherit inputs; };
              users.razboy     = import ./home/home.nix;
              sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };

    ############################################################################
    # ── Stand-alone Home-Manager profile (optional) ───────────────────────────
    ############################################################################
    homeConfigurations = {
      razboy = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.vscode-ext.overlays.default   # ← NEW: VS Code extensions
          ];
          config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs; };
        modules          = [ ./home/home.nix ];
      };
    };
  };
}
