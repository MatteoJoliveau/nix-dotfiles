{ pkgs, ... }:
let
  nodejs = pkgs.nodejs-16_x;
  yarn = pkgs.yarn;
  clang = pkgs.clang_10;
in
{
  home.packages = with pkgs; [
    nodejs
    yarn
    clang
    meson
    cmake
    rustup
    unstable.httpie
    insomnia
    unstable.awscli2
    unstable.ssm-session-manager-plugin
    kubectl
    k9s
    kubectx
    kubie
    unstable.kubernetes-helm
    kustomize
    krew
    minikube
    kind
    asciinema
    jq
    yq
    ruby_2_7
    terraform
    adoptopenjdk-bin
    zola
    lazygit
    git-town
    argocd
    unstable.jetbrains.idea-ultimate
    doctl
    unstable.saml2aws
    jo
    vpnc
    remmina
    velero
    google-cloud-sdk
  ];

  programs.vscode.enable = true;
}
