{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; rec {
    unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {
      config = {
        allowUnfree = true;
      };
    };

    multilockscreen = callPackage pkgs/multilockscreen.nix { };
    boundary = callPackage pkgs/boundary.nix { };
    krew = callPackage pkgs/krew.nix { };
    email-sync = callPackage pkgs/email-sync.nix { };
    rofi-rbw = callPackage pkgs/rofi-rbw.nix {
      pypkgs = python39Packages;
    };
    rofimoji = callPackage pkgs/rofimoji.nix {
      pypkgs = python39Packages;
    };
    wonderdraft = callPackage pkgs/wonderdraft {};
  };

  # Look, I don't like this either, but they are slow to fix those CVEs
  permittedInsecurePackages = [
    "libsixel-1.8.6"
    "python2.7-Pillow-6.2.2"
  ];
}
