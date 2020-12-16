# Nix Dotfiles

Nix recipes for my personal workstations.

## Install 

### System Config

TODO

### Home Config

First, install `home-manager`. More updated information can be found on [the official repo](https://github.com/nix-community/home-manager/#installation), but a quick cheatsheet is provided below.

```bash

# $RELEASE matches the desired channel. For example use `master` for the main branch or `release-20.09` for the stable release.
nix-channel --add https://github.com/nix-community/home-manager/archive/$RELEASE.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
```

Clone the repository somewhere handy. The cloned directory will be symlinked with the files' final destination so that any change
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

```bash
.
├── nix                                 # Niv directory
├── nixos                               # NixOS system configurations
│  ├── common.nix                         # Shared config
│  └── frenchpenguin                      # Frenchpenguin (work laptop) specific configs
│     ├── configuration.nix
│     └── hardware-configuration.nix
├── nixpkgs                             # Home-Manager configuration
│  ├── common.nix                         # Shared config
│  ├── config.nix                         # Nixpkgs config
│  ├── configs                            # Miscellaneous config files
│  ├── home.nix                           # Main HM config (only imports common.nix and ${hostname}.nix)
│  ├── hosts                              # System-specific configurations
│  │  └── frenchpenguin.nix                 # Frenchpenguin (work laptop) specific configs
│  ├── images                             # Various images
│  ├── install.sh                         # Install script
│  ├── modules                            # Reusable components that install and configure various aspects of the system
│  │  ├── alacritty.nix                     # Alacritty (terminal emulator)
│  │  ├── coreutils.nix                     # System core components (vim, exa, environment variables, etc)
│  │  ├── desktop.nix                       # GUI-related software (chats, email, Steam, file explorer, GTK theme, etc) [1]
│  │  ├── development.nix                   # Sofware development tools (editors, compilers, language runtimes, etc)
│  │  ├── fish.nix                          # Fish shell
│  │  ├── git.nix                           # Git
│  │  ├── gpg.nix                           # GPG and Keybase
│  │  ├── greenclip.nix                     # Greenclip config (clipboard manager [2])
│  │  └── xmonad.nix                        # XMonad configuration (includes DE-less tools like Rofi, Picom, Dunst, etc)
│  ├── pkgs                               # Custom packages not available on nixpkgs
│  └── xmonad                             # XMonad configuration
│     ├── xmobar.hs                         # XMobar config
│     ├── xmonad-session-rc                 # Symlinked to `.xprofile` for starting up services and preparing the graphical environment
│     └── xmonad.hs                         # XMonad main config
└── shell.nix                             # Nix Shell config
```

1: DEs and window managers are installed system-wide and configured locally
2: *For various reasons Greenclip is actually installed and started in `/etc/nixos/configuration.nix` but starts as a user service.*

## Gotchas

### Bitwarden Rofi (bwmenu)

`bwmenu` needs some changes to the key configuration in order to work. These changes are configured in the fixup stage of the [derivation](./nixpkgs/pkgs/bitwarden-rofi.nix#L22), but it's a bit finicky. In case of errors like these:

```
keyctl_set_timeout: Permission denied
keyctl_read_alloc: Permission denied
```

Simply run the following command. It only needs to be run once.

```bash
nix-shell -p keyutils --run "keyctl link @u @s"
```

## Contributing

This repo is (unsurprisingly) managed with [Nix Shells].

It requires having `nix-shell` and `direnv` installed and available, in which case it should configure everything 
automatically when entering the root dir from a shell prompt.

[Niv] is used for dependency management.

### Formatting

`*.nix` source files are formatted using [`nixpkgs-fmt`](https://github.com/nix-community/nixpkgs-fmt).

[Nix Shells]: https://nixos.wiki/wiki/Development_environment_with_nix-shell
[Niv]: https://github.com/nmattia/niv