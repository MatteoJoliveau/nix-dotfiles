{ pkgs, ... }:

{
  home.packages = with pkgs; [
    email-sync
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
        astroid = {
          enable = true;
          sendMailCommand = "msmtp --read-envelope-from --read-recipients";
        };
        msmtp.enable = true;
        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotify = "/usr/bin/env";
          onNotifyPost = {
            mail = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
          };
        };
      };
    };
  };

  services.mbsync = {
    enable = true;
    frequency = "*:*:0/50"; # every 50s, this is so that systemd uses the precise default of 1m minimum resolution.
    postExec = "${pkgs.email-sync}/bin/email-sync";
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch.enable = true;
    astroid = {
      enable = true;
      externalEditor = "alacritty -e vim -c 'set ft=mail' '+set tw=72' %1";

      extraConfig = {
        poll.interval = 0;
        editor.attachment_directory = "~/Downloads/mails";
        thread_view = {
          open_html_part_external = "true";
        };
        startup.queries = {
          todo = "tag:todo";
        };
      };
    };
  };

  # Enable when Home Manager 21.05 comes out with goimapnotify instead of node-imapnotify
  services.imapnotify.enable = false;
}