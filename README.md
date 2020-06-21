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

```shell
mkdir -p ~/.ssh && scp secret_location/id_rsa* ~/.ssh
git clone git@github.com:HammockSunburn/dotfiles-home.git
sudo dnf install fish
fish dotfiles-home/setup.fish
```

I've written a [fish script](setup.fish) that automates my initial setup tasks to make a cozy home for me. `setup.fish` is idempotent like any good automation should be. It does things such as:

* Install non-Fedora DNF repositories
* Install packages not included in the default Fedora workstation setup
* Install `vim-plug` and `PlugInstall` my neovim plugins
* Use `dconf` to configure Gnome with my preferences
* Link files in this repository, like my `tmux` configuration, into their correct locations
* Install `rustup` and a various Rust programs that aren't yet packaged for Fedora
* Enable the ssh server
