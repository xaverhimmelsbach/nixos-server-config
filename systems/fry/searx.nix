{ config, ... }: {
  age.secrets.searx-environment = {
    file = ../../secrets/searx-environment.age;
  };

  users.groups."acme-search.himmelsbach.dev" = {
    members = [ "acme" "nginx" ];
  };

  security.acme = {
    certs."search.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-search.himmelsbach.dev";
    };
  };

  services.nginx = {
    # TODO: SLD as variable?
    virtualHosts."search.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/search.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/search.himmelsbach.dev/key.pem";
      locations."/" = {
        # TODO: Port variable
        proxyPass = "http://127.0.0.1:8888";
      };
    };
  };

  services.searx = {
    enable = true;
    environmentFile = config.age.secrets.searx-environment.path;
    settings = {
      server = {
        port = 8888;
        bind_address = "0.0.0.0";
        secret_key = "@SEARX_SECRET_KEY@";
      };
    };
  };
}
