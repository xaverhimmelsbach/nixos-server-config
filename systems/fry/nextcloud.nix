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

  age.secrets.coturn-static-auth-secret= {
    file = ../../secrets/coturn-static-auth-secret.age;
    mode = "770";
    owner = "turnserver";
    group = "turnserver";
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
    package = pkgs.nextcloud29;
    hostName = "himmelsbach.dev";
    https = true;
    config = {
      adminpassFile = config.age.secrets.nextcloud-root-pw.path;
    };
    configureRedis = true;
  };

  users.groups."acme-himmelsbach.dev" = {
    members = [
      "acme"
      "turnserver"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "xaver.himmelsbach@gmail.com";
    certs."himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-himmelsbach.dev";
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/himmelsbach.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/himmelsbach.dev/key.pem";
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.coturn-static-auth-secret.path;
    realm = "himmelsbach.dev";
    cert = "/var/lib/acme/himmelsbach.dev/cert.pem";
    pkey = "/var/lib/acme/himmelsbach.dev/key.pem";
    no-cli = true;
    # https://nextcloud-talk.readthedocs.io/en/latest/coturn/
    extraConfig = ''
      fingerprint
      total-quota=0
      bps-capacity=0
      stale-nonce
      no-multicast-peers
    '';
  };
}
