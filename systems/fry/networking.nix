{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv6.addresses = [
          {
            address = "2a01:4f8:1c17:5b17::1";
            prefixLength = 64;
          }
          {
            address = "fe80::9400:3ff:feb5:ee56";
            prefixLength = 64;
          }
        ];
        ipv6.routes = [{
          address = "fe80::1";
          prefixLength = 128;
        }];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="96:00:03:b5:ee:56", NAME="eth0"
  '';
}
