#! /usr/bin/env bash

homedir=$( getent passwd "$USER" | cut -d: -f6 )
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
dst="$homedir/.config/nixpkgs"

usage() {
    echo "Usage: install.sh [flags]"
    echo ""
    echo "Symlinks the proper NixOS configuration for this machine the target directory (defaults to $dst). Safe to be run multiple times."
    echo ""
    echo "    --dry-run   prints the commands it would run without actually executing them"
    echo "  -h, --help    prints this message and exits"
    exit 1
}

unknown() {
    echo "Unknown argument '$1'"
    exit 1
}

run() {
    if [ ! -z "$DRY_RUN_CMD" ]; then
        echo "SIMULATED DRY RUN"
        echo ""
    fi

    echo "Installing Nixpkgs"
    echo "Removing $dst for clean symlink"
    $DRY_RUN_CMD rm -rf "$dst"
    echo "Linking $here to $dst"
    $DRY_RUN_CMD ln -s "$here" "$dst"
    echo "Done"
    echo ""
    echo "Now you can run home-manager switch to activate your home configuration"
}

for arg in "$@"; do
  shift
  case "$arg" in
    "-h"|"--help") usage ;;
    "--dry-run") DRY_RUN_CMD="echo" ;;
    *) unknown "$arg"
  esac
done

run