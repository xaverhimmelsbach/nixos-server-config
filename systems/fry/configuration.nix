{ stateVersion, ... }:
{
  lib,
  pkgs,
  config,
  ...
}:

{
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    helix
    zellij
    inetutils
    dnsutils
  ];

  environment.variables.EDITOR = "hx";

  time.timeZone = "Europe/Berlin";

  networking.hostName = "fry";

  boot.tmp.cleanOnBoot = true;

  zramSwap.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOU6AXkMMuvqnuF+5hEqYRHvbAebES8XUo2eVfxRjcD xaver@standin" # id_hetzner
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtcmtJaH+j3jb3DOnvHTEDBv1hTeWtLEbwPARgSVgbX xaver@standin" # id_hetzner_sftp
  ];

  system.stateVersion = stateVersion;
}
