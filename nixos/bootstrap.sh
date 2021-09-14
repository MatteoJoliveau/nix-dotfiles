#! /usr/bin/env bash

default_dst="/etc/nixos"
default_hostname="$( hostname )"

usage() {
    local dst="$1"
    local hostname="$2"
    echo "Usage: bootstrap.sh [flags] [TARGETDIR] [HOSTNAME]"
    echo ""
    echo "Copies the initial NixOS configuration for this machine into the target directory (defaults to $dst). Should only be run once and then switch to install.sh, but overrall safe to be run multiple times."
    echo ""
    echo "Arguments"
    echo "  TARGETDIR     directory where the configuration will be installed. Optional, defaults to $dst"
    echo "  HOSTNAME      installed system hostname. Optional, defaults to '$( hostname )'"
    echo ""
    echo "Options"
    echo "    --dry-run   prints the commands it would run without actually executing them"
    echo "  -h, --help    prints this message and exits"
    exit 1
}

run() {
    local dst="$1"
    local hostname="$2"

    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root"
        exit 1
    fi

    if [ ! -z "$DRY_RUN_CMD" ]; then
        echo "SIMULATED DRY RUN"
        echo ""
    fi

    here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

    if [ ! -d "$here/$hostname" ]; then
      echo "Unknown host \"$hostname\", did you forget to add its directory?"
      echo "Available hosts:"
      echo ""
      ls -d $here/*/ | xargs -I '{}' basename '{}'
      exit 1
    fi

    echo "Adding nixos-hardware channel"
    $DRY_RUN_CMD nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    $DRY_RUN_CMD nix-channel --update

    echo "Installing NixOS configuration"

    echo "Removing $dst for clean symlink"
    $DRY_RUN_CMD rm -rf "$dst"
    $DRY_RUN_CMD mkdir -p "$dst"

    echo "Linking $here/common.nix to $dst/common.nix"
    $DRY_RUN_CMD cp "$here/common.nix" "$dst/common.nix"

    echo "Linking $here/codexlab-ca.crt to $dst/codexlab-ca.crt"
    $DRY_RUN_CMD cp "$here/codexlab-ca.crt" "$dst/codexlab-ca.crt"

    echo "Linking $here/$hostname/configuration.nix to $dst/configuration.nix"
    $DRY_RUN_CMD cp "$here/$hostname/configuration.nix" "$dst/configuration.nix"

    echo "Linking $here/$hostname/hardware-configuration.nix to $dst/hardware-configuration.nix"
    $DRY_RUN_CMD cp "$here/$hostname/hardware-configuration.nix" "$dst/hardware-configuration.nix"

    echo "Patching paths in $dst/configuration.nix"
    $DRY_RUN_CMD sed "s@../common.nix@./common.nix@g" "$dst/configuration.nix" -i

    echo "Done"
    echo ""
    echo "Now you can run nixos-install to complete the installation process"

}

for arg in "$@"; do
  shift
  case "$arg" in
    "-h" | "--help") usage "$default_dst" "$default_hostname" ;;
    "--dry-run") DRY_RUN_CMD="echo" ;;
    *) if [ -z "$dst" ]; then dst="$arg"; else hostname="$arg"; fi
  esac
done

if [ -z "$dst" ]; then
  dst="$default_dst"
fi

if [ -z "$hostname" ]; then
  hostname="$default_hostname"
fi

run "$dst" "$hostname"