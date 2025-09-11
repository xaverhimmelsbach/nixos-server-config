{ config, ... }:
{
  users.groups."acme-dns.himmelsbach.dev" = {
    members = [
      "acme"
      "nginx"
    ];
  };

  security.acme = {
    certs."dns.himmelsbach.dev" = {
      dnsProvider = "hetzner";
      environmentFile = config.age.secrets.hetzner-api-key.path;
      group = "acme-dns.himmelsbach.dev";
    };
  };

  services.nginx = {
    virtualHosts."dns.himmelsbach.dev" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/dns.himmelsbach.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/dns.himmelsbach.dev/key.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
    };
  };

  networking.nameservers = [ "127.0.0.1" ];

  services.adguardhome = {
    enable = true;
    settings = {
      http = {
        address = "127.0.0.1:3000";
      };
      dns = {
        bind_hosts = [
          "0.0.0.0"
          "::1"
          "fc00::1"
        ];
        upstream_dns = [ "9.9.9.9" ]; # Quad9
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search = {
          enabled = false;
        };
      };
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt"
          ];
    };
  };
}
