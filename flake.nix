{
  description = "A very basic flake";

  inputs = {
    # change to github:nixos/nixpkgs/nixos-23.05 for stable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # change to github:nix-community/home-manager/release-23.05 for stable
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
    nixosConfigurations = let
      user = "reddy";
      buildHost = host:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";

          specialArgs = {
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs system user;
          };

          modules = [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = {
                  imports = [
                    # common home-manger configuration
                    ./nixos/home.nix
                    # host specific home-manger configuration
                    ./nixos/hosts/${host}/home.nix
                  ];

                  home = {
                    username = user;
                    homeDirectory = "/home/${user}";
                    # do not change this value
                    stateVersion = "23.05";
                  };

                  # Let Home Manager install and manage itself.
                  programs.home-manager.enable = true;
                };
              };
            }
            # shared common configuration
            ./nixos/configuration.nix
            # host specific configuration
            ./nixos/hosts/${host}/configuration.nix
            # host specific hardware configuration
            ./nixos/hosts/${host}/hardware-configuration.nix
          ];
        };
    in {
      # update with `nix flake update`
      # rebuild with `nixos-rebuild switch --flake .#panther`
      panther = buildHost "panther";
    };
  };
}
