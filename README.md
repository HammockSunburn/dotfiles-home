# Hammock's dotfiles

## Tools

I primarily use tools that have out-of-the-box configurations which I find pleasing. This means I require minimal customization.

* Fish with the [`jorgebucaran/fisher`](https://github.com/jorgebucaran/fisher) package manager, [`danhper/fish-ssh-agent`](https://github.com/danhper/fish-ssh-agent) and [`jethrokuan/fzf`](https://github.com/jethrokuan/fzf)
* VS Code with the following extensions:
  * Rust
  * GitLens
  * Markdown All in One
  * markdownlint
  * Better TOML
  * Gruvbox Theme (with Gruvbox Hard Dark)
* Neovim

## Fedora Setup

I use Fedora Workstation and this is my cheatsheet. I install some packages which aren't included with the base Fedora installation:

```shell
sudo dnf install \
         bat \
         cascadia-code-fonts \
         clang \
         cmake \
         exa \
         fd-find \
         fish \
         fzf \
         gcc-c++ \
         gnome-tweaks \
         make \
         neovim \
         ninja-build \
         openssl-devel \
         ripgrep \
         starship \
         tmux-powerline \
         util-linux-user
```

To set up Rust, I use [`rustup`](https://rustup.rs/), cross my fingers, and directly run shell scripts received over the internet:

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

There are some Rust-based tools that aren't currently packaged for Fedora that I install. I used to also install `starship` via cargo, but Fedora now packages it and keeps it pretty up-to-date.

```shell
cargo install du-dust
cargo install xsv
```

To get [`vim-plug`](https://github.com/junegunn/vim-plug) ready, I cry a little inside and let the internet mess around in my home directory:

```shell
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

In the root of this repository is a poorly-written fish script, `setup.fish`, that makes a lot of assumptions that are correct for me, but probably wrong for you. This needs to be run before I use `chsh` to change shells since it will muck about with the fish configuration. This sets up a `gnome-terminal` profile for Gruvbox Dark with my preferred font and makes it the default. Also, this script adds VSCode's RPM-based repositories to Fedora. Then, I install VSCode (stable):

```shell
sudo dnf check-update
sudo dnf install code
```

Finally, I change my default shell using `chsh` to `/usr/bin/fish`.