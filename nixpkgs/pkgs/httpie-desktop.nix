{ stdenv, lib
, fetchurl
, makeDesktopItem
, writeShellScriptBin
, appimage-run
, makeWrapper
}:

let
  runner = writeShellScriptBin "httpie-desktop" ''
        ${appimage-run}/bin/appimage-run HTTPie.AppImage
      '';
in
stdenv.mkDerivation rec {
  name = "httpie-desktop";

  version = "2022.14.0";

  src = fetchurl {
    url = "https://github.com/httpie/desktop/releases/download/v${version}/HTTPie-${version}.AppImage";
    sha256 = "1ymbbrfkrdr7vqs9w3prljjf08xxl1k59dam1gnjb1q1p0w91smy";
  };

  phases = ["unpackPhase" "installPhase"];

  nativeBuildInputs = [
  ];


  buildInputs = [
    makeWrapper
    appimage-run
    runner
  ];

  unpackPhase = ''
    for srcFile in $src; do
      cp $srcFile $(stripHash $srcFile)
    done
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    install -m755 -D HTTPie-${version}.AppImage $out/lib/HTTPie.AppImage
    install -m755 -D ${runner}/bin/httpie-desktop $out/bin/${name}
    substituteInPlace $out/bin/${name} --replace 'HTTPie.AppImage' "$out/lib/HTTPie.AppImage"

    cp -r ${desktopItem}/share $out/share
  '';

   desktopItem = makeDesktopItem {
    name = name;
    exec = name;
    icon = name;
    desktopName = "HTTPie Desktop";
    genericName = meta.description;
    categories = ["Development"];
    terminal = false;
  };

  meta = with lib; {
    homepage = "https://httpie.io/product";
    description = "🚀 HTTPie for Desktop — cross-platform API testing client for humans. Painlessly test REST, GraphQL, and HTTP APIs.";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}