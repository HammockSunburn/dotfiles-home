# Hammock's dotfiles

## Tools

I primarily use tools that have out-of-the-box configurations which I find pleasing, but I've still found a lot of things that I like to customize.

My primary toolset is:

* Fish with the [`jorgebucaran/fisher`](https://github.com/jorgebucaran/fisher) package manager, [`danhper/fish-ssh-agent`](https://github.com/danhper/fish-ssh-agent) and [`jethrokuan/fzf`](https://github.com/jethrokuan/fzf)
* GNU Emacs, VS Code, sometimes Neovim
* tmux
* C++, Rust

## Fedora Setup

I've written a [bash script](setup.bash) that automates my initial setup tasks to make a cozy home for me. `setup.bash` is idempotent like any good automation should be.

```shell
mkdir -p ~/.ssh && scp secret_location/id_rsa* ~/.ssh
git clone git@github.com:HammockSunburn/dotfiles-home.git
bash dotfiles-home/setup.bash
# after it finishes, log out and back in to pick up the changes
```
