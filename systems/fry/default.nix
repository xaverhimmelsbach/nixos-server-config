{ pkgs, lib, agenix, stateVersion }:
{
  inherit pkgs;
  modules = [
    (import ./hardware-configuration.nix)
    (import ./configuration.nix {
      inherit pkgs;
      inherit lib;
      inherit stateVersion;
    })
    (import ./networking.nix {
      inherit lib;
    })
    (import ./security.nix)
    (import ./wireguard.nix)
    (import ./nginx.nix)
    (import ./acme.nix)
    (import ./nextcloud.nix)
    (import ./turn.nix)
    (import ./adguard.nix)
    (import ./kavita.nix)
    (import ./searx.nix)
    agenix.nixosModules.default
  ];
}
