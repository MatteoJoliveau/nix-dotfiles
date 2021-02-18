#! /usr/bin/env bash

dst="/etc/nixos"

usage() {
    echo "Usage: bootstrap.sh [flags] [TARGETDIR]"
    echo ""
    echo "Copies the initial NixOS configuration for this machine into the target directory (defaults to $dst). Should only be run once and then switch to install.sh, but overrall safe to be run multiple times."
    echo ""
    echo "    --dry-run   prints the commands it would run without actually executing them"
    echo "  -h, --help    prints this message and exits"
    exit 1
}

run() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root"
        exit 1
    fi

    if [ ! -z "$DRY_RUN_CMD" ]; then
        echo "SIMULATED DRY RUN"
        echo ""
    fi

    hostname="$( hostname )"
    here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

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
    echo "Now you can run nixos-rebuild switch to activate the system configuration"

}

for arg in "$@"; do
  shift
  case "$arg" in
    "-h"|"--help") usage ;;
    "--dry-run") DRY_RUN_CMD="echo" ;;
    *) dst="$arg"
  esac
done

run