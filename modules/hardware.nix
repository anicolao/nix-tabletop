# Hardware-specific configuration module
# Contains hardware settings and optimizations
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    tabletop.hardware = {
      enable = mkEnableOption "hardware-specific configuration";

      bluetooth = {
        powerOnBoot = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to power on Bluetooth at boot";
        };
      };
    };
  };

  config = mkIf config.tabletop.hardware.enable {
    hardware.bluetooth.powerOnBoot = config.tabletop.hardware.bluetooth.powerOnBoot;
  };
}

