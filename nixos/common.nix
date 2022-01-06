{ config, pkgs, ... }:

{
  # Automatically optimise the Nix store
  nix.autoOptimiseStore = true;
  # Automatically cleanup derivation older than a month each week
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.enableIPv6 = true;
  networking.extraHosts =
    ''
      127.0.0.1 containers.localhost
      ::1 containers.localhost
    '';

  # Configure GRUB 
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };

    grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      enableCryptodisk = true;
    };
  };

  boot.plymouth.enable = true;

  # tmp on tmpfs
  boot.tmpOnTmpfs = true;

  # Add custom CA certs
  security.pki.certificates = [ (builtins.readFile ./codexlab-ca.crt) ];

  # Add Kernel modules
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  time.timeZone = "Europe/Rome";

  # OpenDoas
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" ]; keepEnv = true; persist = true; }
    ];
  };

  # NTP
  services.chrony.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    bind
    wget
    vim
    neofetch
    cpufetch
    git
    xorg.xmodmap
    docker-compose
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    plymouth
    virt-manager
    usbutils
  ];

  nixpkgs.config.allowUnfree = true;

  # Look, I don't like this either, but they are slow to fix those CVEs
  nixpkgs.config.permittedInsecurePackages = [
    "libsixel-1.8.6"
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;

    media-session.config.bluez-monitor.rules = [
      {
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            "bluez5.msbc-support" = true;
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          { "node.name" = "~bluez_input.*"; }
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  # For steam
  hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "eurosign:e ctrl:nocaps";
  };

  # Configure LightDM Enso theme
  services.xserver.displayManager.lightdm.greeters.enso = {
    enable = true;
    blur = true;
  };

  # Enable xmonad
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  services.redshift = {
    enable = true;
    temperature.day = 6500;
  };

  location.provider = "geoclue2";

  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

  # Enable Virt Manager
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
  };

  # USB devices (Yubikey, Logitech receiver)
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.solaar pkgs.yubikey-personalization pkgs.libu2f-host ];

  # Pretty much means that there's logitech hardware.
  # This ensures they always can be used during initrd.
  boot.initrd.kernelModules = [
    "hid_logitech_dj"
    "hid_logitech_hidpp"
  ];

  # Accounts Service
  services.accounts-daemon.enable = true;

  # Thumbnail Service
  services.tumbler.enable = true;

  # User accounts
  programs.fish.enable = true;
  users.users.matteo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "libvirtd" ];
    shell = pkgs.fish;
  };

  xdg.portal.enable = true;
  services.flatpak.enable = true;

  services.gvfs.enable = true;

  system = {
    stateVersion = "21.11";
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = false;
  };

}
