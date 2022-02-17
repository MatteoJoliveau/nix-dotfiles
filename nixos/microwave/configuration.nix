{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> {
    config.allowUnfree = true;
  };
in
{
  imports =
    [
      # Include common configuration
      ../common.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/common/cpu/amd>
      <nixos-hardware/common/pc/ssd>
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Drawing tablet support
  hardware.opentabletdriver.enable = true;

  # services.xserver.digimend.enable = true;

  # boot.extraModulePackages = with config.boot.kernelPackages; [ digimend ];
  # environment.etc."X11/xorg.conf.d/50-huion.conf".source = ./50-huion.conf;
  # boot.postBootCommands = ''
  #   primary_out=$(xrandr --current | grep primary | awk '{ print $1 }')
  #   pen_id=$(xinput list | grep Pen | grep -oP 'id=(\d*)' | awk -F = '{ print $2 }')
  #   xinput map-to-output "$pen_id" $primary_out || true
  # '';


  # Networking
  networking.hostName = "microwave"; # Define your hostname
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Use NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.displayManager = {
    defaultSession = "none+xmonad";
    setupCommands = ''
      #!/bin/sh
      ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate left --output DP-0 --off --output DP-1 --off --output DP-2 --primary --mode 2560x1440 --rate 144 --pos 3640x240 --rotate normal --output DP-3 --off --output DP-4 --mode 2560x1080 --pos 1080x420 --rotate normal --output DP-5 --off
    '';
  };
}
