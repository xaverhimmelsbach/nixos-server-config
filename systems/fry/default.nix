{ pkgs, lib, agenix, stateVersion }: {
  inherit pkgs;
  modules = [
    (import ./hardware-configuration.nix)
    (import ./configuration.nix { inherit stateVersion; })
    (import ./networking.nix)
    (import ./security.nix)
    (import ./wireguard.nix)
    (import ./nginx.nix)
    (import ./acme.nix)
    (import ./nextcloud.nix)
    (import ./turn.nix)
    (import ./adguard.nix)
    (import ./kavita.nix)
    (import ./navidrome.nix)
    (import ./searx.nix)
    (import ./firefly-iii.nix)
    (import ./freshrss.nix)
    (import ./paperless.nix)
    (import ./infrastructure/postgresql.nix)
    agenix.nixosModules.default
  ];
}
