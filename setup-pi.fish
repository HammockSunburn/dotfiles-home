#!/usr/bin/fish
# Possibly useful if you use Raspberry Pi OS on a Raspberry Pi 4,
# probably not useful otherwise.

sudo true
set -x dotfiles_dir (dirname (readlink -m (status --current-filename)))

mkdir -p "$HOME/.local/share/fonts/caskaydia"
if test ! -e "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    wget -O "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
    unzip -d "$HOME/.local/share/fonts/caskaydia" "$HOME/.local/share/fonts/caskaydia/CascadiaCode.zip"
    fc-cache -v
end

# Basic shell, editor, tmux configuration.
echo -n Basic shell, editor, tmux configuration...
mkdir -p "$HOME/.config" "$HOME/.emacs.d"
rm -rf "$HOME/.config/fish"; and ln -s "$dotfiles_dir/config/fish" "$HOME/.config"
ln -sf "$dotfiles_dir/config/nvim" "$HOME/.config"
ln -sf "$dotfiles_dir/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_dir/tmux-gruvbox-dark.conf" "$HOME/.config"
ln -sf "$dotfiles_dir/config/bashtop" "$HOME/.config"
ln -sf "$dotfiles_dir/gitconfig" "$HOME/.gitconfig"
ln -sf "$dotfiles_dir/emacs/init.el" "$HOME/.emacs.d"
#rm -rf "$HOME/.config/broot"; and ln -s "$dotfiles_dir/config/broot" "$HOME/.config"
mkdir -p "$HOME/.ssh"
chmod o-rwx,g-rwx "$HOME/.ssh"
echo Done!

sudo apt install -y \
     clang \
     cmake \
     emacs \
     exa \
     fd-find \
     fish \
     fzf \
     info \
     libssl-dev \
     locate \
     make \
     neovim \
     ninja-build \
     ripgrep \
     python3-virtualenv \
     vlc \
     weechat \
     youtube-dl

# Change shell if necessary
set -x current_shell (getent passwd $USER | awk -F: '{print $NF}')
if [ "$current_shell" != '/usr/bin/fish' ]
    chsh -s /usr/bin/fish
end

# Setup vim-plug
if test ! -e "$HOME/.local/share/nvim/site/autoload/plug.vim"
    echo Installing vim-plug and getting plugins...
    curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" \
        --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    nvim +PlugInstall +qall 
else
    nvim --headless +PlugClean +qall
end

# Setup rust
if test ! -d "$HOME/.cargo"
    echo Installing rustup...
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | /bin/bash -s -- -y
    source $HOME/.cargo/env
end

# Ensure rust is up-to-date
rustup toolchain install nightly stable

# Install certain rust programs from source. I install "nu" from source, too, but it always rebuilds even when
# there are no changes, so for now, I just do that by hand when I want to update it.
cargo install \
          broot \
          du-dust \
          git-delta \
          mdcat \
          procs \
          starship \
          tokei \
          xsv \
          zoxide

# Enable sshd service
#sudo systemctl enable sshd.service
#sudo systemctl start sshd.service

# Ensure I'm in the dialout and lock groups for Arduino.
#sudo usermod -a -G dialout,lock (whoami)

# Setup email and name for this repository.
cd "$dotfiles_dir"
git config user.name "Hammock Sunburn"
git config user.email "hammocksunburn@gmail.com"

# Synchronize any new emacs packages
emacs -batch -l $HOME/.emacs.d/init.el
#systemctl --user enable emacs
#systemctl --user restart emacs

# Virtualenv for various python tools
cd $HOME
if test ! -d "$HOME/virtualenv"
    python3 -m venv virtualenv
end

$HOME/virtualenv/bin/pip install --upgrade pip

# Update the locate db
sudo updatedb > /dev/null 2>&1
