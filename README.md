# Nix Dotfiles

Nix recipes for my personal workstations.

## Install 

### System Config

TODO

### Home Config

First, install `home-manager`. More updated information can be found on [the official repo](https://github.com/nix-community/home-manager/#installation), but a quick cheatsheet is provided below.

```bash

# $RELEASE matches the desired channel. For example use `master` for the main branch or `release-20.03` for the stable release.
nix-channel --add https://github.com/nix-community/home-manager/archive/$RELEASE.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
```

Clone the repository somewhere handy. The clone directory will be symlinked with the files' final destination so that any change
made to this repo will instantly reflect on the target system.

```bash
git clone git@github.com:matteojoliveau/nix-dotfiles.git ~/nix-dotfiles
```

Finally run the install script. It will install the home configuration for the current user.

```bash
cd ~/nix-dotfiles
./nixpkgs/install.sh
home-manager switch
```

The script will delete and relink the target directory on every invocation, so it is safe to run multiple times.
Running `home-manager switch` will update the system with the defined configuration.

## Structure

## Contributing

This repo is (unsurprisingly) managed with [Nix Shells].

It requires having `nix-shell` and `direnv` installed and available, in which case it should configure everything 
automatically when entering the root dir from a shell prompt.

[Niv] is used for dependency management.
### Formatting

`*.nix` source files are formatted using [`nixpkgs-fmt`](https://github.com/nix-community/nixpkgs-fmt).

[Nix Shells]: https://nixos.wiki/wiki/Development_environment_with_nix-shell
[Niv]: https://github.com/nmattia/niv