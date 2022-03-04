{ config, pkgs, ... }:

{
  imports =
    [
      # Include common configuration
      ../common.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixos-hardware/common/pc/laptop>
      <nixos-hardware/common/cpu/intel>
    ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking
  networking.hostName = "frenchpenguin"; # Define your hostname
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Additional packages
  environment.systemPackages = with pkgs; [
    firehol
  ];

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
  services.tlp.enable = true;
  powerManagement.powertop.enable = true;

  # Enable Thunderbolt
  services.hardware.bolt.enable = true;

  # Use the Intel drivers
  services.xserver.videoDrivers = [ "intel" ];

  services.autorandr.enable = true;

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      additionalOptions = ''MatchIsTouchpad "on"'';
    };
  };
}
