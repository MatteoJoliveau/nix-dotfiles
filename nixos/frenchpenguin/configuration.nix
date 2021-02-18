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


  # Networking
  networking.hostName = "frenchpenguin"; # Define your hostname
  networking.networkmanager.enable = true;
  networking.interfaces.wlp59s0.useDHCP = true;
  networking.extraHosts =
    ''
      127.0.0.1 containers.localhost
      ::1 containers.localhost
      172.17.0.2 minikube containers.minikube
    '';

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    config = {
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

  services.fprintd = {
    enable = true;
    package = (pkgs.callPackage ./fprint/fprintd.nix { });
  };

  services.autorandr.enable = true;

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    naturalScrolling = true;
    additionalOptions = ''MatchIsTouchpad "on"'';
  };
}
