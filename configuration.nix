# Main configuration file - now modularized
# This file imports and configures the various system modules
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Import all modules
  imports = [
    ./modules/base-system.nix
    ./modules/networking.nix
    ./modules/hardware.nix
    ./modules/users.nix
  ];

  # Enable all modules with default configuration
  tabletop = {
    baseSystem.enable = true;
    networking.enable = true;
    hardware.enable = true;
    users.enable = true;
  };

  boot.kernelParams = ["console=ttyAMA0,115200"];
  boot.initrd.compressor = "gzip";

  # Kiosk mode setup
  services.cage = {
    enable = true;
    user = "kiosk";
    program = "${pkgs.chromium}/bin/chromium --kiosk --incognito https://www.google.com";
  };
  systemd.services.cage = {
    requires = ["time-sync.target"];
    after = ["time-sync.target"];
  };

  # OpenGL
  hardware.graphics.enable = true;
  # Define the kiosk user
  users.users.kiosk = {
    isNormalUser = true;
    extraGroups = ["video" "input" "wheel"];
  };

  # Minimal graphical environment & auto-login session
  services.greetd = {
    enable = false;
    settings = {
      initial_session = {
        command = ''
          ${pkgs.cage}/bin/cage -- \
          ${pkgs.chromium}/bin/chromium \
          --enable-features=UseOzonePlatform \
          --ozone-platform=wayland \
          --kiosk \
          --disable-infobars \
          --no-first-run \
          "https://www.google.com"
        '';
        user = "kiosk";
      };
    };
  };
}
