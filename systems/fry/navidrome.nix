{ config, ... }:
{
  users.groups."acme-music.himmelsbach.dev" = {
    members = [
      "acme"
      "nginx"
    ];
  };

  security.acme = {
    certs."music.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-music.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."music.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/music.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/music.himmelsbach.dev/key.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:4533";
      };
    };
  };

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/var/lib/navidrome/music";
      DataFolder = "/var/lib/navidrome/data";
      BaseUrl = "https://music.himmelsbach.dev";
    };
  };
}
