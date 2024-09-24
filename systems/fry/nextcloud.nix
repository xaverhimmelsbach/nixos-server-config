{ pkgs, config, ... }: {
  age.secrets.nextcloud-root-pw = {
    file = ../../secrets/nextcloud-root-pw.age; 
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };

  age.secrets.hetzner-api-key = {
    file = ../../secrets/hetzner-api-key.age; 
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "himmelsbach.dev";
    https = true;
    config = {
      adminpassFile = config.age.secrets.nextcloud-root-pw.path;
    };
    configureRedis = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/himmelsbach.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/himmelsbach.dev/key.pem";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "xaver.himmelsbach@gmail.com";
    certs."himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "nginx";
    };
  };
}
