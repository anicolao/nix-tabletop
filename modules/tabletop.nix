{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    pihole.service = {
      enable = mkEnableOption "Pi-hole DNS filtering service";

      interface = mkOption {
        type = types.str;
        default = "end0";
        description = "Network interface for Pi-hole to bind to";
      };

      upstreamDNS = mkOption {
        type = types.listOf types.str;
        default = ["8.8.8.8"];
        description = "Upstream DNS servers";
      };

      webPort = mkOption {
        type = types.str;
        default = "8080";
        description = "Port for Pi-hole web interface";
      };
    };
  };
}

