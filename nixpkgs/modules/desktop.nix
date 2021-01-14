{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    feh
    libsecret
    mailspring
    firefox
    aerc
    w3m
    dante
    slack
    teams
    discord
    zoom-us
    gvfs
    glib
    tdesktop
    bitwarden
    bitwarden-cli
    spotify
    unstable.yubioath-desktop
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    gnome3.gnome-keyring
    gnome3.seahorse
    steam
    steam-run-native
    libreoffice-fresh
    deluge
    audacity
  ];

  home.file.".face".source = ../images/propic.jpeg;

  home.sessionVariables = {
    GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
    NSS_DEFAULT_DB_TYPE = "sql";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita";
      package = pkgs.gnome3.gnome_themes_standard;
    };
    font =
      {
        package = pkgs.roboto;
        name = "Roboto 11";
      };
    gtk3.extraConfig.gtk-cursor-theme-name = "breeze";
  };

  qt = {
    platformTheme = "gtk";
  };

  xresources = {
    properties = {
      "Xft.dpi" = "110";
    };
  };

  home.activation.installNssDbCerts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ffdir=$HOME/.mozilla/firefox/$(ls $HOME/.mozilla/firefox | grep default)
    if ! { [ -L "$ffdir/key4.db" ] && [ -L "$ffdir/cert9.db" ]; };
    then 
      $DRY_RUN_CMD mv $ffdir/key4.db $ffdir/cert9.db $HOME/.pki/nssdb/
      $DRY_RUN_CMD ln -s ~/.pki/nssdb/key4.db $ffdir/key4.db
      $DRY_RUN_CMD ln -s ~/.pki/nssdb/cert9.db $ffdir/cert9.db
    fi
    $DRY_RUN_CMD ${pkgs.nss.tools}/bin/certutil -A -t "C,," -n codexlab -i /etc/nixos/codexlab-ca.crt -d sql:$HOME/.pki/nssdb
  '';
}
