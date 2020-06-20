# Hammock's dotfiles

## Tools

I primarily use tools that have out-of-the-box configurations which I find pleasing. This means I require minimal customization.

* Fish with the [`jorgebucaran/fisher`](https://github.com/jorgebucaran/fisher) package manager, [`danhper/fish-ssh-agent`](https://github.com/danhper/fish-ssh-agent) and [`jethrokuan/fzf`](https://github.com/jethrokuan/fzf)
* VS Code with the following extensions:
  * rust-analyzer
  * GitLens
  * Markdown All in One
  * markdownlint
  * Better TOML
  * Gruvbox Theme (with Gruvbox Hard Dark)
* Neovim
* tmux

## Fedora Setup

I use Fedora Workstation and this is my cheatsheet. I've written two simple Ansible playbooks that I run locally to get my workstation ready for use. The first, `root-setup.yml` does a variety of setup tasks as `root`, such as setting up extra `dnf` repositories and installing packages which aren't part of the default Fedora Workstation installation.

```shell
ansible-playbook -K root-setup.yml
```

The second playbook, `user-setup.yml`, does user specific setup (e.g., `tmux` and `nvim` configuration) as whatever user is currently logged in.

```shell
ansible-playbook user-setup.yml
```

Now, I log out and back in to pick up the changes, such as the default shell which is now changed to `fish`.

Ansible's support for `dconf` is poor, so the next step is done manually outside of the normal Ansible automation. This configures my Gnome desktop preferences for Terminal and the window manager:

```shell
dconf load /org/gnome/terminal/ < gnome-terminal-prefs.dconf
dconf load /org/gnome/desktop/wm/preferences/ < gnome-wm-prefs.dconf
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

Next, I start `nvim` and run the `PlugInstall` command to get my plugins installed.

It's good to get the locate db primed in case I need to use `locate` before the usual update:

```shell
sudo updatedb
```
