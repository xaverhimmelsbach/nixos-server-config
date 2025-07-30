{ config, ... }: {
  users.groups."acme-watch.himmelsbach.dev" = {
    members = [ "acme" "nginx" ];
  };

  security.acme = {
    certs."watch.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-watch.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."watch.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/watch.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/watch.himmelsbach.dev/key.pem";
      locations."/" = { proxyPass = "http://127.0.0.1:8096"; };
    };
  };

  services.jellyfin = {
    enable = true;
  };
}
