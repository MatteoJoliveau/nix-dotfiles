{ pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.starship
    git-town
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      hk = "heroku";
      tf = "terraform";
      k = "kubectl";
      ktx = "kubectx";
      kns = "kubens";
      isodate = "date -u +'%Y-%m-%dT%H:%M:%SZ'";
      g = "git";
      gt = "git town";
      ls = "exa";
      lg = "lazygit";
      rng = "ranger";
      cp = "cp -a --reflink=auto";
      rebar = "rebar3";
      compose = "docker-compose";
      clip = "xclip -sel clip";
      nethack = "telnet nethack.alt.org";
      ed = "emacs -nw";
      find = "fd";
      cat = "bat";
      cal = "cal -m";
      reset_bg = "eval (~/.fehbg)";
      kwskadmin = "kubectl exec -it openwhisk-wskadmin -n openwhisk -- wskadmin";
      "code." = "code .";
      # sudo = "doas";
      hm = "home-manager";
      tree = "ls -T";
      finlogin = "kubelogin -n finleap-dev --username matteo.joliveau --password (bw get password 'Finleap LDAP'); and sed \"s@fcloud/dev-ca.pem@$HOME/.kube/fcloud/dev-ca.pem@g\" ~/.kube/config -i";
    };

    promptInit = "eval (starship init fish)";

    shellInit = ''
      eval (direnv hook fish)
      eval (git town completions fish)
    '';

    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "df1333899d5562c7a4e419e3bfc650aa5d2fd103";
          sha256 = "1nyh85ji75j3a23czbaaf9s66dpfhfd9in5b6s5baispi2qfwdh2";
        };
      }
    ];

    functions = {
      be = "bundle exec $argv";
      cdso = ''
        set software_path ~/Software
        if count $argv > /dev/null
          cd $software_path/$argv[1]
        else
          cd $software_path
        end
      '';
      goodnight = ''
        read -l -P 'Shutting down. Confirm? [y/N] ' confirm
    
        switch $confirm
          case Y y
            shutdown -h now
          case \'\' N n
            return 0
        end
      '';
      update-branch = ''
          set help "Update Branch - Copyright ©2018 Matteo Joliveau

        Usage

        update-branch --source \$SOURCE_BRANCH --target \$TARGET_BRANCH
        "
   

          getopts $argv | while read -l key value
            switch $key
              case "source"
                set source $value
              case "target"
                set target $value
              case "h" "help"
                echo "$help"
                return 0
            end
          end

          if test -z $source
            set source "develop"
          end

          if test -z $target
            set target (git rev-parse --abbrev-ref HEAD)
          end

          git checkout $source
          git pull
          git checkout $target
          git merge --ff-only $source
      '';
    };
  };
}
