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
    httpie
    insomnia
    awscli
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
    terraform_0_15
    adoptopenjdk-bin
    zola
    lazygit
    git-town
    argocd
    jetbrains.idea-ultimate
    doctl
    saml2aws
  ];

  programs.vscode.enable = true;
}
