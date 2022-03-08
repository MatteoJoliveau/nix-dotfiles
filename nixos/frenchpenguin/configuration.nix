{ config, pkgs, ... }:

{
  imports =
    [
      # Include common configuration
      ../common.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/dell/xps/15-9500/nvidia>
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.hostName = "frenchpenguin"; # Define your hostname
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Additional packages
  environment.systemPackages = with pkgs; [
    firehol
  ];

  hardware.opengl = {
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];

  # Power management
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 85;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };
  powerManagement.powertop.enable = true;

  # Enable Thunderbolt
  services.hardware.bolt.enable = true;

  # Please NVIDIA don't drain my battery
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.powerManagement.finegrained = true;

  services.autorandr.enable = true;

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      additionalOptions = ''MatchIsTouchpad "on"'';
    };
  };

  security.polkit.enable = true;
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.xscreensaver.fprintAuth = true;

}
