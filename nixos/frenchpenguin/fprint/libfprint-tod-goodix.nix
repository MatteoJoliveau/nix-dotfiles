{ stdenv
, pkgs
, fetchgit
, libfprint-tod ? (pkgs.callPackage ./libfprint-tod-clean.nix { })
, git
, autoPatchelfHook
, libusb
, glibc
,
}:
stdenv.mkDerivation rec {
  pname = "libfprint-2-tod1-xps9300-bin";
  version = "0.0.6";

  src = fetchgit {
    url = "git://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-goodix/+git/libfprint-2-tod1-goodix/";
    rev = "882735c6366fbe30149eea5cfd6d0ddff880f0e4";
    sha256 = "1x9h5x027s2avdhjhnfmmhdpgyf9x79fz8skcjd3rm3phnpr3zsj";
  };

  buildInputs = [
    libfprint-tod
    git
    libusb
    autoPatchelfHook
    glibc
  ];

  installPhase = ''
    install -dm 755 "$out/lib/udev/rules.d/"
    install -dm 755 "$out/usr/lib/libfprint-2/tod-1/"

    sed -n -r '/Shenzhen/,/^\s*$/p' debian/copyright > LICENSE
    install -Dm644 LICENSE "$out/usr/share/licenses/libfprint-2-tod1-xps9300-bin/LICENSE"

    install -Dm 755 usr/lib/x86_64-linux-gnu/libfprint-2/tod-1/libfprint-tod-goodix-53xc-0.0.6.so "$out/usr/lib/libfprint-2/tod-1/"
    install -Dm 0755 lib/udev/rules.d/60-libfprint-2-tod1-goodix.rules "$out/lib/udev/rules.d/"
  '';

  meta = with stdenv.lib; {
    homepage = "https://git.launchpad.net/~oem-solutions-engineers/libfprint-2-tod1-goodix/+git/libfprint-2-tod1-goodix";
    description = "Goodix driver module for libfprint-2 Touch OEM Driver";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jobojeha ];
  };
}
