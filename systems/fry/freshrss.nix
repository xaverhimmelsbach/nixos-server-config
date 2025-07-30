{ config, ... }:
{
  age.secrets.freshrss-admin-password = {
    file = ../../secrets/freshrss-admin-password.age;
    mode = "770";
    owner = "freshrss";
    group = "freshrss";
  };

  users.groups."acme-freshrss.himmelsbach.dev" = {
    members = [
      "acme"
      "nginx"
    ];
  };

  security.acme = {
    certs."freshrss.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-freshrss.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."freshrss.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/freshrss.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/freshrss.himmelsbach.dev/key.pem";
    };
  };

  services.postgresql = {
    ensureDatabases = [ "freshrss" ];
    ensureUsers = [
      {
        name = "freshrss";
        ensureDBOwnership = true;
      }
    ];
  };

  services.freshrss = {
    enable = true;
    defaultUser = "admin";
    passwordFile = config.age.secrets.freshrss-admin-password.path;
    baseUrl = "https://freshrss.himmelsbach.dev";
    database = {
      type = "pgsql";
      host = "localhost";
      port = 5432;
      user = "freshrss";
      name = "freshrss";
    };
    virtualHost = "freshrss.himmelsbach.dev";
  };
}
