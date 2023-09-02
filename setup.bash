#!/bin/bash
# Possibly useful if you use Fedora, probably not useful otherwise.

set -e
sudo true
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $DOTFILES_DIR

mkdir -p \
      "$HOME/.config" \
      "$HOME/.emacs.d"

rm -rf "$HOME/.config/fish"
ln -s "$DOTFILES_DIR/config/fish" "$HOME/.config"
ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config"
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/tmux-gruvbox-dark.conf" "$HOME/.config"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.emacs.d"
ln -sf "$DOTFILES_DIR/emacs.d/init.el" "$HOME/.emacs.d"
ln -sf "$DOTFILES_DIR/emacs.d/custom.el" "$HOME/.emacs.d"
mkdir -p "$HOME/.ssh"
chmod o-rwx,g-rwx "$HOME/.ssh"

# VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo cp -f "$DOTFILES_DIR/vscode.repo" /etc/yum.repos.d/

# RPM Fusion
FEDORA_VERSION=`rpm -E %fedora`
sudo dnf install -y \
         https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$FEDORA_VERSION".noarch.rpm \
         https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$FEDORA_VERSION".noarch.rpm

sudo dnf install -y \
    bat \
    cascadia-code-pl-fonts \
    clang \
    clang-tools-extra \
    cmake \
    code \
    emacs \
    exa \
    fd-find \
    fish \
    fontawesome-fonts \
    fzf \
    gcc-c++ \
    git-delta \
    jetbrains-mono-fonts \
    kitty \
    latexmk \
    make \
    neovim \
    ninja-build \
    openssl-devel \
    prettyping \
    procs \
    pv \
    ripgrep \
    texlive \
    texlive-latexindent \
    texlive-supertabular \
    texlive-listings \
    texlive-minted \
    texlive-xcolor \
    tmux \
    tmux-powerline \
    tokei \
    util-linux-user \
    valgrind \
    vlc \
    weechat \
    youtube-dl \
    zoxide

# Bat theme configuration
mkdir -p `bat --config-dir`/themes
ln -sf "$DOTFILES_DIR"/gruvbox.tmTheme `bat --config-dir`/themes
bat cache --build

# Kitty
mkdir -p $HOME/.config/kitty
ln -sf "$DOTFILES_DIR"/config/kitty/kitty.conf $HOME/.config/kitty

# neovim
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config"

# Setup vim-plug
if test ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim"; then
    echo Installing vim-plug and getting plugins...
    curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" \
        --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    nvim +PlugInstall +qall 
else
    nvim --headless +PlugClean +qall
fi

# Setup rust
if test ! -d "$HOME/.cargo"; then
    echo Installing rustup...
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | /bin/bash -s -- -y
    source $HOME/.cargo/env
fi

# Ensure rust is up-to-date
$HOME/.cargo/bin/rustup toolchain install nightly stable

$HOME/.cargo/bin/cargo install \
    du-dust \
    mdcat \
    xsv 

# Enable sshd service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service

# Setup email and name for this repository.
cd "$DOTFILES_DIR"
git config user.name "Hammock Sunburn"
git config user.email "hammocksunburn@gmail.com"

# Update the locate db
sudo updatedb

# Change shell if necessary
chsh -s /usr/bin/fish
