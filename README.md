# Hammock's dotfiles

## Tools

I primarily use tools that have out-of-the-box configurations which I find pleasing, but I've still found a lot of things that I like to customize.

My primary toolset is:

* Fish with the [`jorgebucaran/fisher`](https://github.com/jorgebucaran/fisher) package manager, [`danhper/fish-ssh-agent`](https://github.com/danhper/fish-ssh-agent) and [`jethrokuan/fzf`](https://github.com/jethrokuan/fzf)
* VS Code with the following extensions:
  * Better TOML
  * GitLens
  * Gruvbox Theme (with Gruvbox Hard Dark)
  * HTML CSS Support
  * IntelliSense for CSS class names
  * Markdown All in One
  * markdownlint
  * rust-analyzer
* Neovim
* tmux
* Kitty terminal
* Rust

## Fedora Setup

I've written a [fish script](setup.fish) that automates my initial setup tasks to make a cozy home for me. `setup.fish` is idempotent like any good automation should be.

```shell
mkdir -p ~/.ssh && scp secret_location/id_rsa* ~/.ssh
git clone git@github.com:HammockSunburn/dotfiles-home.git
sudo dnf install fish
fish dotfiles-home/setup.fish
# after it finishes, log out and back in to pick up the changes
```

The `setup.fish` script does things such as:

* Install non-Fedora DNF repositories
* Install packages not included in the default Fedora workstation setup
* Install `vim-plug` and `PlugInstall` my neovim plugins
* Use `dconf` to configure Gnome with my preferences
* Link files in this repository, like my `tmux` configuration, into their correct locations
* Install VS Code extensions I use
* Install `rustup` and a various Rust programs that aren't yet packaged for Fedora
* Enable the ssh server
* Symlink various configuration files into `$HOME` or `$HOME/.config` as needed
* Add me to the appropriate groups from Arduino development
* Update the locate database
