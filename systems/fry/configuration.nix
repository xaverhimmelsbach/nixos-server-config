{ stateVersion, ... }:
{ lib, pkgs, config, ... }:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [ vim curl git helix zellij ];

  environment.variables.EDITOR = "hx";

  time.timeZone = "Europe/Berlin";

  networking.hostName = "fry";

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = false;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOU6AXkMMuvqnuF+5hEqYRHvbAebES8XUo2eVfxRjcD"
  ]; # id_hetzner

  system.stateVersion = stateVersion;
}

