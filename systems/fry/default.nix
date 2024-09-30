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
    (import ./nextcloud.nix)
    (import ./adguard.nix)
    (import ./calibre.nix)
    (import ./searx.nix)
    agenix.nixosModules.default
  ];
}
