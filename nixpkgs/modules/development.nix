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
    minikube
    asciinema
    jq
  ];

  programs.vscode.enable = true;
}
