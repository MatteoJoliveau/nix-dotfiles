{ stdenv, makeWrapper, pkgs, lib }:
let
  name = "email-sync";
  version = "0.1.0";
in
stdenv.mkDerivation {
  name = "${name}";
  src = ../scripts;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = with pkgs; ''
    mkdir -p $out/bin
    install -Dm 755 ./email-sync.sh $out/bin/${name}
    wrapProgram $out/bin/${name} --prefix PATH ":" ${lib.makeBinPath [ bash isync notmuch astroid coreutils libnotify afew procps ]}
  '';

  meta = {
    description = "Sync local email folder";
    longDescription = ''
      Sync local email folder updating notmuch and astroid
    '';
    homepage = "https://github.com/matteojoliveau/${name}";
    license = "MIT";
    platforms = with lib.platforms; linux;
    maintainers = [
      lib.maintainers.matteojoliveau
    ];
  };
}
