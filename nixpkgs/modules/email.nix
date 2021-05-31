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
      };
    };
    afew = {
      enable = true;
      extraConfig = ''
        [MailMover]
        folders = Personal/Inbox Personal/Archive Personal/Trash Personal/Spam Personal/Drafts
        rename = True
        max_age = 15

        Personal/Inbox = 'tag:spam':Personal/Spam 'tag:deleted':Personal/Trash 'NOT tag:inbox OR tag:archived':Personal/Archive
        Personal/Trash = 'NOT tag:deleted AND tag:inbox':Personal/Inbox 'NOT tag:deleted AND tag:draft':Personal/Drafts 'NOT tag:deleted':Personal/Archive
        Personal/Drafts = 'tag:deleted':Personal/Trash
        Personal/Archive =
        Personal/Spam =

        [SpamFilter]
        [KillThreadsFilter]
        [ListMailsFilter]
        [ArchiveSentMailsFilter]

        [Filter.1]
        query = 'dave@dmdave.com'
        tags = +newsletter
        message = DMDave newsletter
      '';
    };
  };

  # Enable when Home Manager 21.05 comes out with goimapnotify instead of node-imapnotify
  services.imapnotify.enable = false;

  home.file = {
    ".mailcap".text = ''
      text/html;  w3m -dump -o document_charset=%{charset} '%s'; nametemplate=%s.html; copiousoutput
    '';
  };
}
