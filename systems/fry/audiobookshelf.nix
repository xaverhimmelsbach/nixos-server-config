{ config, ... }: {
  users.groups."acme-listen.himmelsbach.dev" = {
    members = [ "acme" "nginx" ];
  };

  security.acme = {
    certs."listen.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-listen.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."listen.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/listen.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/listen.himmelsbach.dev/key.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8000";
        proxyWebsockets = true;
      };
    };
  };

  services.audiobookshelf = {
    enable = true;
  };
}
