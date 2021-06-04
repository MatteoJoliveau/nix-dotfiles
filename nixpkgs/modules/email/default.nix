{ pkgs, ... }:

{
  home.packages = with pkgs; [
    email-sync
    urlscan
  ];

  # TODO: cal and card sync with vdirsync (https://github.com/kzar/davemail/blob/main/.vdirsyncerrc)
  accounts.email = {
    maildirBasePath = ".mail";
    accounts = {
      Personal = {
        primary = true;
        address = "matteo@matteojoliveau.com";
        userName = "matteo@matteojoliveau.com";
        realName = "Matteo Joliveau";
        passwordCommand = "${pkgs.gnome3.libsecret}/bin/secret-tool lookup fastmail password";

        gpg = {
          key = "5082F3E1817A0F9ADB54E4EB0E8BD7D975BB89C5";
        };

        imap = {
          host = "imap.fastmail.com";
          port = 993;
          tls = {
            enable = true;
          };
        };

        smtp = {
          host = "smtp.fastmail.com";
          port = 465;
          tls = {
            enable = true;
          };
        };

        notmuch.enable = true;
        mbsync = {
          enable = true;
          patterns = [ "*" ];
          create = "maildir";
        };

        msmtp.enable = true;
        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotify = "/usr/bin/env";
          onNotifyPost = {
            mail = "${pkgs.email-sync}/bin/email-sync";
          };
        };
      };
    };
  };

  services.mbsync = {
    enable = true;
    frequency = "*:0/5"; # every 5m
    postExec = "${pkgs.email-sync}/bin/email-sync";
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch.enable = true;
    alot = {
      enable = true;
      bindings = {
        global = {
            T = "search tag:todo";
        };
        search = {
            t = "toggletags todo";
        };
        thread = {
            B = "call hooks.open_in_browser(ui)";
            O = "pipeto urlscan -- --run xdg-open";
        };
        envelope = {
            B = "call hooks.open_in_browser(ui)";
            O = "pipeto urlscan -- --run xdg-open";
        };
      };
      hooks = builtins.readFile ./alot_hooks.py;
    };
    afew = {
      enable = true;
      extraConfig = builtins.readFile ./afew.cfg;
    };
  };

  # Enable when Home Manager 21.05 comes out with goimapnotify instead of node-imapnotify
  services.imapnotify.enable = false;

  home.file = {
    ".mailcap".text = ''
      text/html;  w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
    '';
  };

  xdg.configFile."urlscan/config.json".source = ./urlscan.json;
}
