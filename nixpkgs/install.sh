#!/usr/bin/env sh

here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "Installing Nixpkgs"
dst="$HOME/.config/nixpkgs"
echo "Removing $dst for clean symlink"
rm -rf "$dst"
echo "Linking $here to $dst"
ln -s "$here" "$dst"
echo "Done"