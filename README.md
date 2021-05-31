# Nix Dotfiles

Nix recipes for my personal workstations.

## Install 

### System Config

The entire system configuration is written in Nix and stored in the `nixos` directory of this repository. It is composed of a common configuration ([common.nix](./nixos/common.nix)) that includes stuff shared between all my machines, and a system-specific config that is stored in a directory matching the target hostname. To add new machines, simply add a new directory with the proper files.

A few convenience scripts are provided to setup the system after first boot.

#### During system install

This guide assumes you have run the regular [NixOS install guide] up until [section 2.3, step 4]. Run the `nixos-generate-config` command to let NixOS detect your hardware, then set aside the `hardware-configuration.nix` file it creates. 

Clone the repository somewhere handy. It doesn't really matter where, as we'll move it to the home folder after first boot. I usually clone it into the `tmp` folder so that it gets cleaned up after rebooting.

```bash
git clone https://github.com/matteojoliveau/nix-dotfiles.git /tmp/nix-dotfiles
```


At this point, instead of manually editing the `configuration.nix` file as it shows, run the `bootstrap.sh` script that can be found in the [nixos](./nixos/bootstrap.sh) directory of this repository. This will copy the appropriate files into the config folder.

```bash
/tmp/nixos/bootstrap.sh /mnt/etc/nixos
```

If you wish to use the generated `hardware-configuration.nix` file instead of the one provided in this repo, copy it to the target folder.

You can now resume following the regular install guide.  
Don't forget to run `passwd my-user` to setup a password for your user (actual username is configured in `common.nix`).

#### After first boot

Once the system is installed and you have rebooted into it with your personal user, clone the repository somewhere handy. The cloned directory will be symlinked with the files' final destination so that any change made to this repo will instantly reflect on the target system.

```bash
git clone https://github.com/matteojoliveau/nix-dotfiles.git ~/nix-dotfiles
```

Now run the install script. It will install the system configuration into the target directory (default is `/etc/nixos`).

```bash
cd ~/nix-dotfiles
nixos/install.sh
doas nix-channel --update
doas nixos-rebuild switch --upgrade
```

The script will delete and relink the target directory on every invocation, so it is safe to run multiple times.
Running `nixos-rebuild switch` will update the system with the defined configuration.


### Home Config

First, install `home-manager`. More updated information can be found on [the official repo](https://github.com/nix-community/home-manager/#installation), but a quick cheatsheet is provided below.

```bash
# $RELEASE matches the desired channel. For example use `master` for the main branch or `release-20.09` for the stable release.
nix-channel --add https://github.com/nix-community/home-manager/archive/$RELEASE.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
```

This guide assumes you have already cloned this repo in your home folder as described in the ["After first boot"](#after-first-boot) section.

Now run the install script. It will install the home configuration for the current user.

```bash
cd ~/nix-dotfiles
nixpkgs/install.sh
home-manager switch
```

The script will delete and relink the target directory on every invocation, so it is safe to run multiple times.
Running `home-manager switch` will update the system with the defined configuration.

## Structure

```bash
.
├── nix                                 # Niv directory
├── nixos                               # NixOS system configurations
│  ├── bootstrap.sh                       # Bootstrap script
│  ├── codexlab-ca.crt                    # Homelab internal CA certificate
│  ├── common.nix                         # Shared config
│  ├── frenchpenguin                      # Frenchpenguin (work laptop) specific configs
│  |  ├── configuration.nix
│  |  └── hardware-configuration.nix
│  ├── install.sh                         # Install script
│  └── microwave                          # Microwave (home desktop) specific configs
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
│  │  ├── bluetooth.nix                     # Bluetooth configuration (for hosts that support it)
│  │  ├── coreutils.nix                     # System core components (vim, exa, environment variables, etc)
│  │  ├── desktop.nix                       # GUI-related software (chats, email, Steam, file explorer, GTK theme, etc) [1]
│  │  ├── development.nix                   # Sofware development tools (editors, compilers, language runtimes, etc)
│  │  ├── email.nix                         # Email setup and tools
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

## Email

The `email.nix` module configures my local email setup. It uses `mbsync` (from the `isync` package) to synchronize the maildir with my remote IMAP provider (currently Fastmail), 
`msmtp` to send emails via the SMTP provider (currently still Fastmail), `notmuch` to index, tag and search emails locally, and `astroid` as the graphical interface to read, search and compose
emails. On first setup of a new host, the following manual steps must be followed:

- add the Fastmail password to the local keychain. Using a device-specific [app password](https://www.fastmail.help/hc/en-us/articles/360058752854-App-passwords) is highly recommended
  Run `secret-tool store --label 'Fastmail password' fastmail password` then type the password in.
- run `mbsync --all` to pull emails from the provider for the first time and initialize the maildir
- exit and re-enter the Linux session (C-z on XMonad) to reload the environment

Emails are polled every 20 seconds by Astroid (which needs to be up and running) using the `email-sync.sh` script which does a few things, including pulling emails, moving archived emails to the `Archive` directory so that they are archived on Fastmail too, and reindexing `notmuch`.

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

[NixOS install guide]: https://nixos.org/manual/nixos/stable/index.html#sec-installation
[section 2.3, step 4]: https://nixos.org/manual/nixos/stable/index.html#sec-installation
[Nix Shells]: https://nixos.wiki/wiki/Development_environment_with_nix-shell
[Niv]: https://github.com/nmattia/niv