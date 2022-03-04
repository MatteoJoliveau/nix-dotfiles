{ pkgs, ... }:

{
  home.packages = with pkgs; [
    starship
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      hk = "heroku";
      tf = "terraform";
      k = "kubectl";
      ktx = "kubie ctx";
      kns = "kubie ns";
      isodate = "date -u +'%Y-%m-%dT%H:%M:%SZ'";
      g = "git";
      ls = "exa";
      grep = "rg";
      lg = "lazygit";
      rng = "ranger";
      cp = "cp -a --reflink=auto";
      rebar = "rebar3";
      compose = "docker-compose";
      clip = "xclip -sel clip";
      nethack = "telnet nethack.alt.org";
      ed = "emacs -nw";
      cat = "bat";
      cal = "cal -m";
      reset_bg = "eval (~/.fehbg)";
      "code." = "code .";
      hm = "home-manager";
      tree = "exa -T";
      ecrlogin = "eval (aws ecr get-login --no-include-email)";
      sb = "sonobuoy";
    };

    interactiveShellInit = "eval (starship init fish)";

    shellInit = ''
      eval (direnv hook fish)
      set -gx PATH $PATH $HOME/.krew/bin
    '';

    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "theme-bobthefish";
          rev = "626bd39b002535d69e56adba5b58a1060cfb6d7b";
          sha256 = "06whihwk7cpyi3bxvvh3qqbd5560rknm88psrajvj7308slf0jfd";
        };
      }
    ];

    functions = {
      be = "bundle exec $argv";
      finlogin = ''
        set env "dev"
        if contains -- --prod $argv 
          set env "prod"
        end
        
        kubelogin -n finleap-$env --username matteo.joliveau $argv --password (rbw get 'Finleap LDAP')
        sed "s@fcloud/$env-ca.pem@$HOME/.kube/fcloud/$env-ca.pem@g" ~/.kube/config -i
      '';
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
   xdg.configFile = {
     "starship.toml".source = ../configs/starship.toml;
   };

  home.file = {
    ".kube/kubie.yaml".source = ../configs/kubie.yaml;
  };
}
