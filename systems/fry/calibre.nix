{ ... }:
let
  library = "/var/lib/calibre-server";
in
{
  users.groups."calibre-all" = {
    members = [
      "calibre-server"
      "calibre-web"
    ];
  };

  services.calibre-server = {
    enable = true;
    group = "calibre-all";
    libraries = [ library ];
    auth = {
      enable = true;
      userDb = "${library}/users.sqlite";
    };
  };

  services.calibre-web = {
    enable = true;
    group = "calibre-all";
    listen = {
      ip = "0.0.0.0";
    };
    options = {
      calibreLibrary = library;
      enableBookConversion = true;
      enableBookUploading = true;
    };
  };
}
