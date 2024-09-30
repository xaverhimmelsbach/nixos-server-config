{ ... }:
{
  age.secrets.hetzner-api-key = {
    file = ../../secrets/hetzner-api-key.age; 
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "xaver.himmelsbach@gmail.com";
  };
}
