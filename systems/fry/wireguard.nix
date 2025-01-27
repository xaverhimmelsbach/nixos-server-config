{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  age.secrets.wireguard-private-key = {
    file = ../../secrets/wireguard-private-key.age;
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ]; # Wireguard port
    trustedInterfaces = [ "wg0" ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      privateKeyFile = config.age.secrets.wireguard-private-key.path;

      peers = [
        { # Oneplus
          publicKey = "UJ57HKzSWYiu8SfHCpngN/OqLNgu0G2MwniU5+eJyTQ=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # Mac
          publicKey = "g+m/NOPNclUUAVxcMDIcS8LzG/eNzFlmMjMSDFUK/io=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        { # Desktop
          publicKey = "MYWcyh02sjhaxrTj9N6NlT+Kvfw2Om/8yJXVn+x1Tk4=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
      ];
    };
  };
}
