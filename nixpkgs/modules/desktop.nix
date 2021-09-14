{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    feh
    libsecret
    firefox
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
    spotify
    yubioath-desktop
    ark
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
    multimc
    obs-studio
    pavucontrol
    paprefs
    vlc
    desktop-file-utils
    scribusUnstable
  ];

  home.file.".face".source = ../images/propic.jpg;

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
        name = "Roboto 14";
      };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "breeze";
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    platformTheme = "gtk";
  };

  xresources = {
    properties = {
      "Xft.dpi" = "110";
    };
  };

  home.activation = {


    installNssDbCerts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      crt="/etc/nixos/codexlab-ca.crt"
      if [ -f "$crt" ]; then
        ffdir=$HOME/.mozilla/firefox/$(ls $HOME/.mozilla/firefox | grep default)
        if ! { [ -L "$ffdir/key4.db" ] && [ -L "$ffdir/cert9.db" ]; };
        then 
          $DRY_RUN_CMD mv $ffdir/key4.db $ffdir/cert9.db $HOME/.pki/nssdb/
          $DRY_RUN_CMD ln -s ~/.pki/nssdb/key4.db $ffdir/key4.db
          $DRY_RUN_CMD ln -s ~/.pki/nssdb/cert9.db $ffdir/cert9.db
        fi
        $DRY_RUN_CMD ${pkgs.nss.tools}/bin/certutil -A -t "C,," -n codexlab -i "$crt" -d sql:$HOME/.pki/nssdb
      fi
    '';

    # Why are we not using xdg.mimeApps to generate the ~/.config/mimeapps.list, you ask?
    # Well it's very simple, if we let Home Manager create and manage the file it will be read only.
    # Which is super useful when you want complete control over the content of the file, but less so
    # when you expect other apps to dynamically update the list as they encounter new mime types they can handle.
    # E.g. when clicking on a link and the browser asks which application to open it with.
    # By running a script that updates the default list like the one here, we avoid having to remember
    # what defaults we set for which type, and still have the mimeapps.list file writeable by other apps.
    setDefaultMimeHandlers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.xdg-utils}/bin/xdg-mime default firefox.desktop application/pdf
      ${pkgs.xdg-utils}/bin/xdg-mime default firefox.desktop image/pdf
      ${pkgs.xdg-utils}/bin/xdg-mime default firefox.desktop text/pdf
    '';
  };
}
