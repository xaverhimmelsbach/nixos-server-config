{ config, ... }:
{
  age.secrets.searx-environment = {
    file = ../../secrets/searx-environment.age;
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
