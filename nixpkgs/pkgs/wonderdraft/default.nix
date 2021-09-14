{ stdenv, lib
, alsaLib
, pulseaudio
, xorg
, libGL
, autoPatchelfHook
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  name = "wonderdraft";

  version = "1.1.6.1";

  src = [
    ./Wonderdraft.x86_64
    ./Wonderdraft.pck
    ./Wonderdraft.png
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    pulseaudio
    alsaLib
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
    libGL
  ];

  sourceRoot = ".";

  unpackPhase = ''
    for srcFile in $src; do
      cp $srcFile $(stripHash $srcFile)
    done
  '';

  installPhase = ''
    install -m755 -D Wonderdraft.x86_64 $out/bin/${name}
    install -m755 -D Wonderdraft.pck $out/bin/${name}.pck
    install -m755 -D Wonderdraft.png $out/share/icons/${name}.png
    cp -r ${desktopItem}/share/applications $out/share
  '';

   desktopItem = makeDesktopItem {
    name = name;
    exec = name;
    icon = name;
    desktopName = "Wondedraft";
    genericName = meta.description;
    categories = "Graphics";
    terminal = false;
  };

  meta = with lib; {
    homepage = "https://www.wonderdraft.net/";
    description = "An intuitive yet powerful fantasy map creation tool for 64-bit Windows 10, Linux, and MacOSX";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}