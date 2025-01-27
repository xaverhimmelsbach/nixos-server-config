{ config, ... }: {
  age.secrets.paperless-admin-password = {
    file = ../../secrets/paperless-admin-password.age;
    mode = "770";
    owner = "paperless";
    group = "paperless";
  };

  age.secrets.paperless-secret-key-env= {
    file = ../../secrets/paperless-secret-key-env.age;
    mode = "770";
    owner = "paperless";
    group = "paperless";
  };

  users.groups."acme-paperless.himmelsbach.dev" = {
    members = [ "acme" "nginx" ];
  };

  security.acme = {
    certs."paperless.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-paperless.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."paperless.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/paperless.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/paperless.himmelsbach.dev/key.pem";
      locations."/" = { proxyPass = "http://127.0.0.1:28981"; };
    };
  };

  services.postgresql = {
    ensureDatabases = [ "paperless" ];
    ensureUsers = [{
      name = "paperless";
      ensureDBOwnership = true;
    }];
  };

  services.paperless = {
    enable = true;
    passwordFile = config.age.secrets.paperless-admin-password.path;
    settings = {
      PAPERLESS_DBHOST = "localhost";
      # PAPERLESS_REDIS=<url>
      # PAPERLESS_TIKA_ENABLED=<bool>
      # PAPERLESS_TIKA_ENDPOINT=<url>
      # PAPERLESS_TIKA_GOTENBERG_ENDPOINT=<url>
      PAPERLESS_OCR_LANGUAGE="deu";
      PAPERLESS_URL="http://127.0.0.1";
    };
    environmentFile = config.age.secrets.paperless-secret-key-env.path;
  };
}
