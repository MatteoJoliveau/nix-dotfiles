{ stdenv, lib
, alsaLib
, pulseaudio
, gnome
, xorg
, libGL
, zlib
, autoPatchelfHook
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  name = "Dungeondraft";

  version = "1.1.6.1";

  src = [
    ./Dungeondraft.x86_64
    ./Dungeondraft.pck
    ./Dungeondraft.png
    ./example_template.zip
    ./data_Dungeondraft
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
    gnome.zenity
    stdenv.cc.cc.lib
    zlib
  ];

  sourceRoot = ".";

  unpackPhase = ''
    for srcFile in $src; do
      cp -r $srcFile $(stripHash $srcFile)
    done
  '';

  installPhase = ''
    install -m755 -D Dungeondraft.x86_64 $out/bin/${name}
    install -m755 -D Dungeondraft.pck $out/bin/${name}.pck
    install -m755 -D example_template.zip $out/bin/example_template.zip
    cp -r data_Dungeondraft $out/bin
    install -m755 -D Dungeondraft.png $out/share/icons/${name}.png
    cp -r ${desktopItem}/share/applications $out/share
  '';

   desktopItem = makeDesktopItem {
    name = name;
    exec = name;
    icon = name;
    desktopName = "Dungeondraft";
    genericName = meta.description;
    categories = ["Graphics"];
    terminal = false;
  };

  meta = with lib; {
    homepage = "https://www.Dungeondraft.net/";
    description = "An intuitive yet powerful fantasy map creation tool for 64-bit Windows 10, Linux, and MacOSX";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}