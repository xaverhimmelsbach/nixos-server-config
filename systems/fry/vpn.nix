{ config, ... }:
{
  age.secrets.wireguard-private-key = {
    file = ../../secrets/wireguard-private-key.age;
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.100.0.5" "fc00::5" ];
      listenPort = 51820;
      dns = [ "10.100.0.1" ];
      privateKeyFile = config.age.secrets.wireguard-private-key.path;
      mtu = 1400;

      peers = [
        {
          publicKey = "n0+zmUu70XMetjJXMxk6voFHmN+KiVsvc5i+ZJALriY=";
          allowedIPs = [
            "10.100.0.1/24"
            "fc00::1/56"
          ];
          endpoint = "vpn.himmelsbach.dev:51820";
          persistentKeepalive = 21;
        }
      ];
    };
  };
}

