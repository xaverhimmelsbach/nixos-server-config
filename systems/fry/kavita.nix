{ config, ... }: {
  users.groups."acme-read.himmelsbach.dev" = { members = [ "acme" "nginx" ]; };

  security.acme = {
    certs."read.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-read.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."read.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/read.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/read.himmelsbach.dev/key.pem";
      locations."/" = { proxyPass = "http://127.0.0.1:5000"; };
    };
  };

  age.secrets.kavita-token-key = {
    file = ../../secrets/kavita-token-key.age;
    mode = "770";
    owner = "kavita";
    group = "kavita";
  };

  services.kavita = {
    enable = true;
    dataDir = "/var/lib/kavita";
    tokenKeyFile = config.age.secrets.kavita-token-key.path;
  };
}
