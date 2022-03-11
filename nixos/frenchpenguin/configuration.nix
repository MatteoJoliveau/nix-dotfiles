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

  # Thanks https://github.com/anderspapitto/nixos-configuration/blob/master/laptop-base.nix
  systemd.services.battery_check = {
    description = "Send notification if battery is low";
    serviceConfig = {
      Type = "oneshot";
      User = "anders";
      ExecStart = pkgs.writeScript "battery_check" ''
        #!${pkgs.bash}/bin/bash --login
        . <(udevadm info -q property -p /sys/class/power_supply/BAT0 |
            grep -E 'POWER_SUPPLY_(CAPACITY|STATUS)=')
        if [[ $POWER_SUPPLY_STATUS = Discharging && $POWER_SUPPLY_CAPACITY -lt  ]];
        then notify-send -u critical "Battery is low: $POWER_SUPPLY_CAPACITY";
        fi
      '';
    };
    environment = { DISPLAY = ":0"; };
    after = [ "display-manager.service" ];
    startAt = "*:00/5";
  };
  services = {
    acpid.enable = true;

    logind.extraConfig = ''
      HoldoffTimeoutSec=0
    '';
  };

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
