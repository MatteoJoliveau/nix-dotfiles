{ config, pkgs, ... }:

{
  imports =
    [
      # Include common configuration
      ../common.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Networking
  networking.hostName = "microwave"; # Define your hostname

  # Use NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.displayManager = {
    defaultSession = "none+xmonad";
    setupCommands = ''
      #!/bin/sh
      ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate left --output DP-0 --off --output DP-1 --off --output DP-2 --primary --mode 1920x1080 --pos 3640x420 --rotate normal --output DP-3 --off --output DP-4 --mode 2560x1080 --pos 1080x420 --rotate normal --output DP-5 --off
    '';
  };
}
