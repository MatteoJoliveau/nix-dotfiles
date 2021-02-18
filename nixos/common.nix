{ config, pkgs, ... }:

{
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

  # System packages
  environment.systemPackages = with pkgs; [
    bind
    wget
    vim
    neofetch
    git
    xorg.xmodmap
    haskellPackages.greenclip
    docker-compose
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    plymouth
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable Greenclip for clipboard history
  services.greenclip.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
    extraConfig = "
      load-module module-switch-on-connect
    ";
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
  services.gnome3.gnome-keyring.enable = true;

  # Enable Docker
  virtualisation.docker.enable = true;

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

  # User accounts
  programs.fish.enable = true;
  users.users.matteo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = pkgs.fish;
  };

  xdg.portal.enable = true;
  services.flatpak.enable = true;

  system.stateVersion = "20.09";
}
