{ pkgs, ... }:
let
  nodejs = pkgs.nodejs-14_x;
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
    awscli2
    kubectl
    k9s
    kubectx
    kubie
    kubernetes-helm
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
    jetbrains.idea-ultimate
    doctl
    saml2aws
    jo
  ];

  programs.vscode.enable = true;
}
