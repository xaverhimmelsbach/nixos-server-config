{ pkgs, config, ... }: {
  age.secrets.nextcloud-root-pw = {
    file = ../../secrets/nextcloud-root-pw.age;
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };

  age.secrets.hetzner-s3-secret = {
    file = ../../secrets/hetzner-s3-secret.age;
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };

  networking.firewall = {
    # allowedTCPPorts = [
    #   443 # Nextcloud
    #   5349 # TURN
    # ];
    allowedUDPPorts = [
      # 5349 # TURN
      51820 # Wireguard port
    ];
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "cloud.himmelsbach.dev";
    https = true;
    config = {
      adminpassFile = config.age.secrets.nextcloud-root-pw.path;
      objectstore.s3 = {
        enable = true;
        bucket = "nextcloud-himmelsbach-dev";
        autocreate = false;
        key = "RJRY61EEF5I1VBA8W0JM";
        secretFile = config.age.secrets.hetzner-s3-secret.path;
        hostname = "fsn1.your-objectstorage.com";
      };
    };
    configureRedis = true;
  };

  users.groups."acme-cloud.himmelsbach.dev" = {
    members = [
      "acme"
      "nginx"
    ];
  };

  security.acme = {
    certs."cloud.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-cloud.himmelsbach.dev";
    };
  };

  services.nginx.virtualHosts = {
    ${config.services.nextcloud.hostName} = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/cloud.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/cloud.himmelsbach.dev/key.pem";
    };
  };
}
