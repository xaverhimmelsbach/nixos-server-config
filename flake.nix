{
  description = "Server config";

  inputs = {
    nixpkgs = { url = "nixpkgs/nixos-unstable"; };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix }:
    let
      inherit (nixpkgs) lib;

      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
    in {
      # Systems
      # All arguments given by lib.nixosSystem
      # ({config, lib, options, specialArgs, modulesPath}: {
      #   ...
      # })
      # To get access to these arguments in one of the modules used in the systems, add a second function parameter in them:
      # {config, lib, ...}:
      nixosConfigurations = {
        fry = lib.nixosSystem (import ./systems/fry {
          inherit pkgs;
          inherit lib;
          inherit agenix;
          stateVersion = "24.05";
        });
      };

    };

}
