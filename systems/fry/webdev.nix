{ config, ... }:
{
  users.groups."acme-juzel.himmelsbach.dev" = {
    members = [
      "acme"
      "nginx"
    ];
  };

  security.acme = {
    certs."juzel.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-juzel.himmelsbach.dev";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8080 ]; # juzel port
  };

  services.nginx = {
    virtualHosts."juzel.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/juzel.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/juzel.himmelsbach.dev/key.pem";
      listen = [
        {
          addr = "[::]";
          port = 8080;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 8080;
          ssl = true;
        }
      ];
      locations."/" = {
        proxyPass = "http://[fc00::3]:8099";
      };
    };
  };
}
