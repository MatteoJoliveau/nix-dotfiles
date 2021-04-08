{ pkgs, ... }:
let
  nodejs = pkgs.unstable.nodejs-14_x;
  yarn = pkgs.yarn;
  clang = pkgs.clang_10;
in
{
  home.packages = with pkgs; [
    nodejs
    yarn
    unstable.jetbrains.idea-ultimate
    clang
    meson
    cmake
    rustup
    httpie
    insomnia
    awscli
    boundary
    kubectl
    k9s
    kubectx
    kubernetes-helm
    kustomize
    krew
    minikube
    unstable.kind
    asciinema
    jq
    yq
    ruby_2_7
    unstable.terraform_0_13
    adoptopenjdk-bin
    zola
    svcat
    lazygit
    git-town
    argocd
  ];

  programs.vscode.enable = true;
}
