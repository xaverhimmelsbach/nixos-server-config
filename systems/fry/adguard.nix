{ ... }:
{
  networking.nameservers = [
    "127.0.0.1"
  ];

  services.adguardhome = {
    enable = true;
    settings = {
      http = {
        address = "0.0.0.0:3000";
      };
      dns = {
        upstream_dns = [
          "9.9.9.9"
        ];
      };
      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search = {
          enabled = false;
        };
      };
      filters = map(url: { enabled = true; url = url; }) [
        "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/pro.txt"
      ];
    };
  };
}
