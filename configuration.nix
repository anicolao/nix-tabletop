# Refactored configuration.nix
{ pkgs, ... }: {
  # Bootloader settings for Raspberry Pi
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelParams = ["console=ttyAMA0,115200"];
  boot.initrd.compressor = "gzip";

  # Networking
  networking.hostName = "tabletop";
  networking.firewall.enable = true;
  # Allow SSH, and web ports for kiosk
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # System timezone and locale
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  # Essential services
  services.openssh.enable = true;
  services.ntp.enable = true;

  # Kiosk mode setup with Cage and Chromium
  services.cage = {
    enable = true;
    user = "kiosk";
    program =
      "${pkgs.chromium}/bin/chromium "
      + "--kiosk "
      + "--incognito "
      # Flags for Wayland and hardware acceleration
      + "--enable-features=UseOzonePlatform,VaapiVideoDecoder "
      + "--ozone-platform=wayland "
      + "--enable-gpu-rasterization "
      + "--enable-zero-copy "
      + "--ignore-gpu-blocklist "
      + "--use-gl=egl "
      # Kiosk experience improvements
      + "--disable-infobars "
      + "--no-first-run "
      + "https://www.google.com";
  };
  systemd.services.cage.requires = ["time-sync.target"];
  systemd.services.cage.after = ["time-sync.target"];


  # The RPi kernel is missing the dw-hdmi module by default.
  # This patch forces it to be built as a module.
  boot.kernelPatches = [{
    name = "enable-dw-hdmi-module";
    patch = null;
    extraConfig = ''
      DRM_DW_HDMI m
    '';
  }];

  # Hardware acceleration for Raspberry Pi 4
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  hardware.graphics.enable = true;

  # Kiosk user
  users.users.kiosk = {
    isNormalUser = true;
    extraGroups = [ "video" "input" ];
  };

  # Allow unfree packages (for some drivers if needed)
  nixpkgs.config.allowUnfree = true;

  # Nix settings for flakes
  nix.settings.experimental-features = "nix-command flakes";

  # System state version
  system.stateVersion = "24.11";
}
