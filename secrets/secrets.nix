let
  fry = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzZ1WaZaxRYiadXRVlnIy63bf+v2IRbbRNGPMSL6jzk";
in
{
  "nextcloud-root-pw.age".publicKeys = [ fry ];
  "hetzner-api-key.age".publicKeys = [ fry ];
  "wireguard-private-key.age".publicKeys = [ fry ];
}
