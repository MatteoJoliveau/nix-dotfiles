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
    docker-compose
    httpie
    insomnia
    awscli
  ];

  programs.vscode.enable = true;
}
