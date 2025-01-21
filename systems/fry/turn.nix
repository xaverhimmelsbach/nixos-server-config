{ config, ... }: {
  age.secrets.coturn-static-auth-secret = {
    file = ../../secrets/coturn-static-auth-secret.age;
    mode = "770";
    owner = "turnserver";
    group = "turnserver";
  };

  users.groups."acme-turn.himmelsbach.dev" = {
    members = [ "acme" "nginx" "turnserver" ];
  };

  security.acme = {
    certs."turn.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-turn.himmelsbach.dev";
    };
  };

  services.nginx.virtualHosts = {
    "turn.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/turn.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/turn.himmelsbach.dev/key.pem";
      locations."/" = { proxyPass = "http://127.0.0.1:5349"; };
    };
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.age.secrets.coturn-static-auth-secret.path;
    realm = "turn.himmelsbach.dev";
    cert = "/var/lib/acme/turn.himmelsbach.dev/cert.pem";
    pkey = "/var/lib/acme/turn.himmelsbach.dev/key.pem";
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
