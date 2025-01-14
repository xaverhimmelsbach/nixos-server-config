{ pkgs, config, ... }: {
  age.secrets.firefly-iii-app-key = {
    file = ../../secrets/firefly-iii-app-key.age;
    mode = "770";
    owner = "firefly-iii";
    group = "nginx";
  };

  users.groups."acme-firefly.himmelsbach.dev" = {
    members = [ "acme" "nginx" ];
  };

  security.acme = {
    certs."firefly.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-firefly.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."firefly.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/firefly.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/firefly.himmelsbach.dev/key.pem";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "firefly-iii" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
    ensureUsers = [{
      name = "firefly-iii";
      ensureDBOwnership = true;
    }];
  };

  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    virtualHost = "firefly.himmelsbach.dev";
    settings = {
      APP_ENV = "production";
      APP_DEBUG = false;
      SITE_OWNER = "mail@example.com";
      APP_KEY_FILE = config.age.secrets.firefly-iii-app-key.path;
      DEFAULT_LANGUAGE = "en_US";
      DEFAULT_LOCALE = "equal";
      TZ = "Europe/Amsterdam";
      TRUSTED_PROXIES = "**"; # Required to serve firefly via nginx
      LOG_CHANNEL = "stack";
      APP_LOG_LEVEL = "notice";
      AUDIT_LOG_LEVEL = "emergency";
      DB_CONNECTION = "pgsql";
      DB_DATABASE = "firefly-iii";
      DB_USERNAME = "firefly-iii";
      DB_SOCKET = "/var/run/postgresql/.s.PGSQL.5432";
      APP_URL = "https://firefly.himmelsbach.dev";
    };
  };
}
